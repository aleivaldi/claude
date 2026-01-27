# Express.js Project Structure

## Directory Tree

```
project-backend/
├── src/
│   ├── index.ts                 # Entry point
│   ├── app.ts                   # Express app configuration
│   ├── server.ts                # Server startup
│   │
│   ├── config/
│   │   ├── index.ts            # Config aggregator
│   │   ├── database.ts         # Database config
│   │   ├── auth.ts             # Auth config (JWT secrets, etc.)
│   │   └── app.ts              # App config (port, env, etc.)
│   │
│   ├── routes/
│   │   ├── index.ts            # Route aggregator
│   │   ├── auth.routes.ts      # /api/v1/auth/*
│   │   ├── users.routes.ts     # /api/v1/users/*
│   │   └── [resource].routes.ts
│   │
│   ├── controllers/
│   │   ├── auth.controller.ts
│   │   ├── users.controller.ts
│   │   └── [resource].controller.ts
│   │
│   ├── services/
│   │   ├── auth.service.ts
│   │   ├── users.service.ts
│   │   └── [resource].service.ts
│   │
│   ├── repositories/
│   │   ├── base.repository.ts   # Generic repository
│   │   ├── users.repository.ts
│   │   └── [resource].repository.ts
│   │
│   ├── middleware/
│   │   ├── auth.middleware.ts       # JWT verification
│   │   ├── validation.middleware.ts # Request validation
│   │   ├── error.middleware.ts      # Global error handler
│   │   ├── logging.middleware.ts    # Request logging
│   │   └── rateLimit.middleware.ts  # Rate limiting
│   │
│   ├── models/
│   │   └── [entity].model.ts    # Domain entities (if not using ORM models)
│   │
│   ├── validations/
│   │   ├── auth.schema.ts       # Zod schemas for auth
│   │   ├── users.schema.ts
│   │   └── common.schema.ts     # Shared schemas
│   │
│   ├── utils/
│   │   ├── logger.ts            # Winston/Pino logger
│   │   ├── errors.ts            # Custom error classes
│   │   ├── response.ts          # Response formatters
│   │   └── helpers.ts           # Utility functions
│   │
│   ├── types/
│   │   ├── express.d.ts         # Express type extensions
│   │   ├── api.types.ts         # API request/response types
│   │   └── models.types.ts      # Model types
│   │
│   └── generated/               # Prisma generated client (gitignored)
│
├── prisma/
│   ├── schema.prisma            # Database schema
│   ├── migrations/              # Migration files
│   └── seed.ts                  # Seed script
│
├── tests/
│   ├── unit/
│   │   ├── services/
│   │   └── utils/
│   ├── integration/
│   │   └── api/
│   └── setup.ts                 # Test configuration
│
├── .env.example                 # Environment template
├── .eslintrc.js
├── .prettierrc
├── jest.config.js
├── tsconfig.json
├── package.json
└── README.md
```

## Key Files Content

### src/index.ts
```typescript
import { startServer } from './server';

startServer();
```

### src/app.ts
```typescript
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import { routes } from './routes';
import { errorMiddleware } from './middleware/error.middleware';
import { loggingMiddleware } from './middleware/logging.middleware';

const app = express();

// Security
app.use(helmet());
app.use(cors());

// Parsing
app.use(express.json({ limit: '10kb' }));

// Logging
app.use(loggingMiddleware);

// Routes
app.use('/api/v1', routes);

// Error handling (must be last)
app.use(errorMiddleware);

export { app };
```

### src/routes/index.ts
```typescript
import { Router } from 'express';
import authRoutes from './auth.routes';
import usersRoutes from './users.routes';

const router = Router();

router.use('/auth', authRoutes);
router.use('/users', usersRoutes);

export { router as routes };
```

### src/middleware/error.middleware.ts
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
  if (error instanceof AppError) {
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

  // Unexpected errors
  logger.error('Unexpected error', { error, requestId: req.id });

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

## Package.json Scripts

```json
{
  "scripts": {
    "dev": "tsx watch src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "lint": "eslint src --ext .ts",
    "lint:fix": "eslint src --ext .ts --fix",
    "typecheck": "tsc --noEmit",
    "test": "jest",
    "test:unit": "jest --testPathPattern=tests/unit",
    "test:integration": "jest --testPathPattern=tests/integration",
    "test:coverage": "jest --coverage",
    "test:watch": "jest --watch",
    "db:migrate": "prisma migrate dev",
    "db:migrate:prod": "prisma migrate deploy",
    "db:seed": "tsx prisma/seed.ts",
    "db:studio": "prisma studio",
    "db:generate": "prisma generate"
  }
}
```

## Dependencies

```json
{
  "dependencies": {
    "express": "^4.18.2",
    "cors": "^2.8.5",
    "helmet": "^7.1.0",
    "@prisma/client": "^5.x",
    "zod": "^3.22.4",
    "jsonwebtoken": "^9.0.2",
    "bcryptjs": "^2.4.3",
    "pino": "^8.17.2",
    "dotenv": "^16.3.1"
  },
  "devDependencies": {
    "@types/express": "^4.17.21",
    "@types/node": "^20.x",
    "@types/cors": "^2.8.17",
    "@types/jsonwebtoken": "^9.0.5",
    "@types/bcryptjs": "^2.4.6",
    "typescript": "^5.3.3",
    "tsx": "^4.7.0",
    "prisma": "^5.x",
    "eslint": "^8.56.0",
    "@typescript-eslint/eslint-plugin": "^6.19.0",
    "@typescript-eslint/parser": "^6.19.0",
    "prettier": "^3.2.4",
    "jest": "^29.7.0",
    "@types/jest": "^29.5.11",
    "ts-jest": "^29.1.1",
    "supertest": "^6.3.4",
    "@types/supertest": "^6.0.2"
  }
}
```
