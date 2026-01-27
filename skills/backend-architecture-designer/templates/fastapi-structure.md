# FastAPI Project Structure

## Directory Tree

```
project-backend/
├── app/
│   ├── __init__.py
│   ├── main.py                  # FastAPI app entry
│   ├── config.py                # Settings management
│   │
│   ├── api/
│   │   ├── __init__.py
│   │   ├── deps.py              # Dependency injection
│   │   └── v1/
│   │       ├── __init__.py
│   │       ├── router.py        # API router aggregator
│   │       ├── auth.py          # /api/v1/auth/*
│   │       ├── users.py         # /api/v1/users/*
│   │       └── [resource].py
│   │
│   ├── core/
│   │   ├── __init__.py
│   │   ├── security.py          # JWT, password hashing
│   │   └── exceptions.py        # Custom exceptions
│   │
│   ├── models/
│   │   ├── __init__.py
│   │   ├── base.py              # SQLAlchemy base
│   │   ├── user.py
│   │   └── [entity].py
│   │
│   ├── schemas/
│   │   ├── __init__.py
│   │   ├── user.py              # Pydantic schemas
│   │   └── [entity].py
│   │
│   ├── services/
│   │   ├── __init__.py
│   │   ├── auth.py
│   │   ├── user.py
│   │   └── [entity].py
│   │
│   ├── repositories/
│   │   ├── __init__.py
│   │   ├── base.py              # Generic repository
│   │   ├── user.py
│   │   └── [entity].py
│   │
│   ├── db/
│   │   ├── __init__.py
│   │   ├── session.py           # Database session
│   │   └── init_db.py           # DB initialization
│   │
│   └── utils/
│       ├── __init__.py
│       └── logger.py
│
├── alembic/
│   ├── versions/                # Migration files
│   ├── env.py
│   └── alembic.ini
│
├── tests/
│   ├── __init__.py
│   ├── conftest.py              # Pytest fixtures
│   ├── unit/
│   │   └── services/
│   └── integration/
│       └── api/
│
├── .env.example
├── pyproject.toml
├── requirements.txt
└── README.md
```

## Key Files Content

### app/main.py
```python
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.v1.router import api_router
from app.core.exceptions import setup_exception_handlers
from app.config import settings

app = FastAPI(
    title=settings.PROJECT_NAME,
    version="1.0.0",
    docs_url="/api/docs",
    redoc_url="/api/redoc",
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Exception handlers
setup_exception_handlers(app)

# Routes
app.include_router(api_router, prefix="/api/v1")


@app.get("/health")
async def health_check():
    return {"status": "healthy"}
```

### app/config.py
```python
from pydantic_settings import BaseSettings
from functools import lru_cache


class Settings(BaseSettings):
    PROJECT_NAME: str = "API"

    # Database
    DATABASE_URL: str

    # Auth
    SECRET_KEY: str
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30
    REFRESH_TOKEN_EXPIRE_DAYS: int = 7

    # CORS
    CORS_ORIGINS: list[str] = ["http://localhost:3000"]

    class Config:
        env_file = ".env"


@lru_cache()
def get_settings() -> Settings:
    return Settings()


settings = get_settings()
```

### app/core/exceptions.py
```python
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse


class AppException(Exception):
    def __init__(
        self,
        status_code: int,
        code: str,
        message: str,
        details: dict | None = None
    ):
        self.status_code = status_code
        self.code = code
        self.message = message
        self.details = details


class ValidationException(AppException):
    def __init__(self, message: str, details: dict | None = None):
        super().__init__(400, "VALIDATION_ERROR", message, details)


class AuthenticationException(AppException):
    def __init__(self, message: str = "Authentication required"):
        super().__init__(401, "AUTHENTICATION_ERROR", message)


class AuthorizationException(AppException):
    def __init__(self, message: str = "Insufficient permissions"):
        super().__init__(403, "AUTHORIZATION_ERROR", message)


class NotFoundException(AppException):
    def __init__(self, resource: str):
        super().__init__(404, "NOT_FOUND", f"{resource} not found")


def setup_exception_handlers(app: FastAPI):
    @app.exception_handler(AppException)
    async def app_exception_handler(request: Request, exc: AppException):
        return JSONResponse(
            status_code=exc.status_code,
            content={
                "success": False,
                "error": {
                    "code": exc.code,
                    "message": exc.message,
                    **({"details": exc.details} if exc.details else {}),
                },
            },
        )
```

### app/api/deps.py
```python
from typing import Generator, Annotated
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from jose import JWTError, jwt

from app.db.session import SessionLocal
from app.config import settings
from app.models.user import User

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/v1/auth/login")


def get_db() -> Generator[Session, None, None]:
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


async def get_current_user(
    db: Annotated[Session, Depends(get_db)],
    token: Annotated[str, Depends(oauth2_scheme)],
) -> User:
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
    )
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=["HS256"])
        user_id: str = payload.get("sub")
        if user_id is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception

    user = db.query(User).filter(User.id == user_id).first()
    if user is None:
        raise credentials_exception
    return user


CurrentUser = Annotated[User, Depends(get_current_user)]
DbSession = Annotated[Session, Depends(get_db)]
```

## pyproject.toml

```toml
[tool.poetry]
name = "project-backend"
version = "0.1.0"
description = ""
authors = ["Your Name <your@email.com>"]

[tool.poetry.dependencies]
python = "^3.11"
fastapi = "^0.109.0"
uvicorn = {extras = ["standard"], version = "^0.27.0"}
sqlalchemy = "^2.0.25"
alembic = "^1.13.1"
psycopg2-binary = "^2.9.9"
pydantic = "^2.5.3"
pydantic-settings = "^2.1.0"
python-jose = {extras = ["cryptography"], version = "^3.3.0"}
passlib = {extras = ["bcrypt"], version = "^1.7.4"}
python-multipart = "^0.0.6"

[tool.poetry.group.dev.dependencies]
pytest = "^7.4.4"
pytest-asyncio = "^0.23.3"
httpx = "^0.26.0"
black = "^24.1.1"
ruff = "^0.1.14"
mypy = "^1.8.0"

[tool.ruff]
line-length = 88
select = ["E", "F", "I"]

[tool.mypy]
strict = true

[build-system]
requires = ["poetry-core"]
build-backend = "poetry.core.masonry.api"
```

## Commands

```bash
# Development
uvicorn app.main:app --reload

# Production
uvicorn app.main:app --host 0.0.0.0 --port 8000

# Quality
black app tests
ruff check app tests
mypy app

# Database
alembic revision --autogenerate -m "description"
alembic upgrade head
alembic downgrade -1

# Testing
pytest
pytest tests/unit
pytest tests/integration
pytest --cov=app
```
