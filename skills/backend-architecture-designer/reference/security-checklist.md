# Security Checklist - Backend

## OWASP Top 10 Coverage

### 1. Injection (A03:2021)

- [ ] **SQL Injection**
  - Use parameterized queries (ORM preferred)
  - Never concatenate user input in queries
  - Validate and sanitize all input

- [ ] **NoSQL Injection**
  - Use proper MongoDB operators
  - Validate object structure
  - Avoid `$where` with user input

- [ ] **Command Injection**
  - Avoid shell commands with user input
  - Use exec arrays, not shell strings
  - Whitelist allowed characters

```typescript
// BAD
const result = exec(`ls ${userInput}`);

// GOOD
const result = execFile('ls', [userInput]);
```

### 2. Broken Authentication (A07:2021)

- [ ] **Password Storage**
  - Use bcrypt with cost factor >= 10
  - Never store plaintext passwords
  - Use constant-time comparison

```typescript
import bcrypt from 'bcryptjs';

const hash = await bcrypt.hash(password, 12);
const isValid = await bcrypt.compare(password, hash);
```

- [ ] **Session Management**
  - Regenerate session ID after login
  - Set secure cookie flags
  - Implement session timeout

- [ ] **JWT Security**
  - Use strong secrets (256+ bits)
  - Set reasonable expiration
  - Validate all claims
  - Use RS256 for distributed systems

```typescript
// JWT best practices
const token = jwt.sign(
  { sub: userId, role: user.role },
  process.env.JWT_SECRET,
  {
    expiresIn: '15m',
    algorithm: 'HS256',
    issuer: 'your-app',
    audience: 'your-api'
  }
);
```

### 3. Sensitive Data Exposure (A02:2021)

- [ ] **Transport Security**
  - HTTPS everywhere
  - HSTS headers enabled
  - TLS 1.2+ only

- [ ] **Data at Rest**
  - Encrypt sensitive fields
  - Use environment variables for secrets
  - Never log sensitive data

- [ ] **Response Security**
  - Don't expose internal errors
  - Remove sensitive headers
  - Filter response data

```typescript
// Don't expose internal details
res.json({
  error: 'Authentication failed' // NOT: 'User not found'
});
```

### 4. Security Misconfiguration (A05:2021)

- [ ] **Headers**
```typescript
import helmet from 'helmet';
app.use(helmet());
```

- [ ] **CORS**
```typescript
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(','),
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  credentials: true,
}));
```

- [ ] **Error Messages**
  - Generic messages in production
  - Stack traces only in development
  - Log full errors server-side

### 5. Broken Access Control (A01:2021)

- [ ] **Authorization Checks**
  - Check permissions on every endpoint
  - Verify resource ownership
  - Implement RBAC or ABAC

```typescript
// Check ownership
const resource = await repository.findById(id);
if (resource.userId !== req.user.id && req.user.role !== 'admin') {
  throw new AuthorizationError();
}
```

- [ ] **API Design**
  - Don't rely on hidden URLs
  - Validate all parameters
  - Use UUIDs, not sequential IDs

### 6. Security Logging (A09:2021)

- [ ] **Log Security Events**
  - Login attempts (success/failure)
  - Access denied events
  - Admin actions
  - Data modifications

```typescript
logger.warn({
  event: 'LOGIN_FAILED',
  email: req.body.email,
  ip: req.ip,
  userAgent: req.headers['user-agent'],
  requestId: req.id,
});
```

- [ ] **Don't Log**
  - Passwords
  - Tokens
  - PII unnecessarily
  - Credit card numbers

### 7. Rate Limiting

- [ ] **Global Rate Limit**
  - 100-1000 requests per minute per IP

- [ ] **Auth Endpoints**
  - 5 attempts per 15 minutes
  - Account lockout after failures

- [ ] **API Endpoints**
  - Tier-based limits
  - Slow down responses on limit

### 8. Input Validation

- [ ] **Schema Validation**
  - Validate all input
  - Type checking
  - Length limits
  - Format validation

```typescript
const schema = z.object({
  email: z.string().email().max(255),
  password: z.string().min(8).max(100),
  name: z.string().min(2).max(100).regex(/^[a-zA-Z\s]+$/),
});
```

- [ ] **File Uploads**
  - Validate file type (magic bytes, not extension)
  - Limit file size
  - Scan for malware
  - Store outside webroot

---

## Environment Security

- [ ] No secrets in code
- [ ] No secrets in git
- [ ] Use secret manager in production
- [ ] Different secrets per environment
- [ ] Rotate secrets regularly

---

## Dependency Security

- [ ] Run `npm audit` / `pip check` regularly
- [ ] Keep dependencies updated
- [ ] Use lockfiles
- [ ] Review new dependencies

```bash
npm audit
npm audit fix
npm outdated
```

---

## Quick Security Headers

```typescript
// Helmet sets these automatically
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
Strict-Transport-Security: max-age=31536000; includeSubDomains
Content-Security-Policy: default-src 'self'
```

---

## Database Security

- [ ] Least privilege principle
- [ ] Separate DB users per service
- [ ] Encrypted connections
- [ ] Regular backups encrypted
- [ ] No direct DB access from internet

---

## Pre-Production Checklist

Before going to production:

- [ ] All environment variables set
- [ ] Debug mode disabled
- [ ] Error messages generic
- [ ] HTTPS enforced
- [ ] CORS restricted to production domains
- [ ] Rate limiting enabled
- [ ] Security headers enabled
- [ ] Logging configured
- [ ] Dependencies audited
- [ ] Secrets rotated from development
