# Middleware Patterns

## Standard Middleware Stack

### Order (Critical)

```
1. Request ID          → Generate trace ID
2. Logging (entry)     → Log request start
3. Rate Limiting       → Protect from abuse
4. CORS                → Cross-origin policy
5. Body Parser         → Parse request body
6. Authentication      → Verify identity
7. Authorization       → Check permissions
8. Validation          → Validate input
9. Route Handler       → Business logic
10. Logging (exit)     → Log response
11. Error Handler      → Catch-all errors (MUST be last)
```

---

## Express.js Patterns

### Request ID Middleware

```typescript
import { v4 as uuidv4 } from 'uuid';

export const requestIdMiddleware = (req, res, next) => {
  req.id = req.headers['x-request-id'] || uuidv4();
  res.setHeader('X-Request-Id', req.id);
  next();
};
```

### Logging Middleware

```typescript
import { logger } from '../utils/logger';

export const loggingMiddleware = (req, res, next) => {
  const start = Date.now();

  res.on('finish', () => {
    const duration = Date.now() - start;
    logger.info({
      method: req.method,
      url: req.url,
      status: res.statusCode,
      duration: `${duration}ms`,
      requestId: req.id,
    });
  });

  next();
};
```

### Rate Limiting

```typescript
import rateLimit from 'express-rate-limit';

export const rateLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: {
    success: false,
    error: {
      code: 'RATE_LIMIT_EXCEEDED',
      message: 'Too many requests, please try again later',
    },
  },
  standardHeaders: true,
  legacyHeaders: false,
});

// Stricter limit for auth endpoints
export const authRateLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5,
  message: {
    success: false,
    error: {
      code: 'RATE_LIMIT_EXCEEDED',
      message: 'Too many login attempts',
    },
  },
});
```

### Authentication Middleware

```typescript
import jwt from 'jsonwebtoken';
import { AuthenticationError } from '../utils/errors';

export const authMiddleware = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;

    if (!authHeader?.startsWith('Bearer ')) {
      throw new AuthenticationError('No token provided');
    }

    const token = authHeader.substring(7);
    const payload = jwt.verify(token, process.env.JWT_SECRET);

    req.user = payload;
    next();
  } catch (error) {
    if (error instanceof jwt.TokenExpiredError) {
      return next(new AuthenticationError('Token expired'));
    }
    if (error instanceof jwt.JsonWebTokenError) {
      return next(new AuthenticationError('Invalid token'));
    }
    next(error);
  }
};

// Optional auth - doesn't fail if no token
export const optionalAuthMiddleware = async (req, res, next) => {
  try {
    const authHeader = req.headers.authorization;

    if (authHeader?.startsWith('Bearer ')) {
      const token = authHeader.substring(7);
      const payload = jwt.verify(token, process.env.JWT_SECRET);
      req.user = payload;
    }
    next();
  } catch {
    next(); // Continue without user
  }
};
```

### Authorization Middleware

```typescript
import { AuthorizationError } from '../utils/errors';

export const requireRole = (...roles: string[]) => {
  return (req, res, next) => {
    if (!req.user) {
      return next(new AuthenticationError('Not authenticated'));
    }

    if (!roles.includes(req.user.role)) {
      return next(new AuthorizationError(`Requires role: ${roles.join(' or ')}`));
    }

    next();
  };
};

// Usage: router.get('/admin', authMiddleware, requireRole('admin'), handler)
```

### Validation Middleware

```typescript
import { z, ZodSchema } from 'zod';
import { ValidationError } from '../utils/errors';

export const validate = (schema: ZodSchema) => {
  return async (req, res, next) => {
    try {
      const validated = await schema.parseAsync({
        body: req.body,
        query: req.query,
        params: req.params,
      });

      req.validated = validated;
      next();
    } catch (error) {
      if (error instanceof z.ZodError) {
        const details = error.errors.reduce((acc, err) => {
          const path = err.path.slice(1).join('.');
          acc[path] = err.message;
          return acc;
        }, {});

        return next(new ValidationError('Validation failed', details));
      }
      next(error);
    }
  };
};

// Schema example
const createUserSchema = z.object({
  body: z.object({
    email: z.string().email(),
    password: z.string().min(8),
    name: z.string().min(2),
  }),
});

// Usage: router.post('/users', validate(createUserSchema), handler)
```

### Error Handler (Global)

```typescript
import { Request, Response, NextFunction } from 'express';
import { AppError } from '../utils/errors';
import { logger } from '../utils/logger';

export const errorMiddleware = (
  error: Error,
  req: Request,
  res: Response,
  _next: NextFunction
) => {
  // Log error
  logger.error({
    error: error.message,
    stack: error.stack,
    requestId: req.id,
    method: req.method,
    url: req.url,
  });

  // Operational error (expected)
  if (error instanceof AppError && error.isOperational) {
    return res.status(error.statusCode).json({
      success: false,
      error: {
        code: error.code,
        message: error.message,
        ...(error.details && { details: error.details }),
      },
      requestId: req.id,
    });
  }

  // Programming error (unexpected)
  return res.status(500).json({
    success: false,
    error: {
      code: 'INTERNAL_ERROR',
      message: 'An unexpected error occurred',
    },
    requestId: req.id,
  });
};
```

---

## FastAPI Patterns

### Middleware Dependencies

```python
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/login")


async def get_current_user(token: str = Depends(oauth2_scheme)) -> User:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=["HS256"])
        user_id: str = payload.get("sub")
        if user_id is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception

    user = await user_repository.get_by_id(user_id)
    if user is None:
        raise credentials_exception
    return user


def require_role(*roles: str):
    async def role_checker(user: User = Depends(get_current_user)) -> User:
        if user.role not in roles:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail="Insufficient permissions",
            )
        return user
    return role_checker
```

### Rate Limiting (SlowAPI)

```python
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded

limiter = Limiter(key_func=get_remote_address)
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)


@app.get("/api/resource")
@limiter.limit("100/minute")
async def get_resource(request: Request):
    pass
```

### Request ID Middleware

```python
from starlette.middleware.base import BaseHTTPMiddleware
import uuid


class RequestIDMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        request_id = request.headers.get("X-Request-ID", str(uuid.uuid4()))
        request.state.request_id = request_id

        response = await call_next(request)
        response.headers["X-Request-ID"] = request_id
        return response
```
