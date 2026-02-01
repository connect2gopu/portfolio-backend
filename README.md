# Portfolio Backend API

Backend service for portfolio website built with Spring Boot, supporting both PostgreSQL and MongoDB.

## Features

- ✅ Spring Boot 3.2.0
- ✅ PostgreSQL support (via Spring Data JPA)
- ✅ MongoDB support (via Spring Data MongoDB)
- ✅ URL-based API versioning (v1, v2)
- ✅ Health check endpoint
- ✅ Production-ready configuration

## Prerequisites

- Java 17 or higher
- Java 17 or higher
- Gradle 8.5+ (Wrapper provided)
- PostgreSQL (for SQL database)
- MongoDB (for NoSQL database)

## Setup

### 1. Clone and Build

```bash
cd portfolio-backend
./gradlew clean build
```

### 2. Configure Database Connections

Edit `src/main/resources/application.yml` or set environment variables:

**PostgreSQL:**
```bash
export POSTGRES_URL=jdbc:postgresql://localhost:5432/portfolioDb
export POSTGRES_USERNAME=postgres
export POSTGRES_PASSWORD=your_password
```

**MongoDB:**
```bash
export MONGODB_URI=mongodb://localhost:27017/portfolioDb
export MONGODB_DATABASE=portfolioDb
```

### 3. Run the Application

**Without databases (for testing health endpoint only):**
```bash
./gradlew bootRun --args='--spring.profiles.active=local'
```

**Development (with databases):**
```bash
./gradlew bootRun --args='--spring.profiles.active=dev'
```

**Production (with databases):**
```bash
./gradlew bootRun --args='--spring.profiles.active=prod'
```

**Default (with databases):**
```bash
./gradlew bootRun
```

Or build and run the JAR:
```bash
./gradlew clean build
java -jar build/libs/portfolio-backend-1.0.0.jar --spring.profiles.active=prod
```

## API Endpoints

### Health Check

**v1:**
```bash
GET http://localhost:8080/v1/health
```

**v2:**
```bash
GET http://localhost:8080/v2/health
```

**Response:**
```json
{
  "status": "UP",
  "timestamp": "2026-01-26T10:30:00",
  "service": "portfolio-backend",
  "version": "1.0.0"
}
```

## Project Structure

```
portfolio-backend/
├── src/
│   ├── main/
│   │   ├── java/com/portfolio/
│   │   │   ├── config/          # Configuration classes
│   │   │   ├── controller/      # REST controllers
│   │   │   │   ├── v1/          # v1 API endpoints
│   │   │   │   └── v2/          # v2 API endpoints
│   │   │   ├── repository/      # Data repositories
│   │   │   │   ├── sql/         # JPA repositories
│   │   │   │   └── nosql/       # MongoDB repositories
│   │   │   └── PortfolioBackendApplication.java
│   │   └── resources/
│   │       ├── application.yml
│   │       ├── application-dev.yml
│   │       └── application-prod.yml
│   └── test/                    # Test files
├── build.gradle.kts
├── settings.gradle.kts
└── README.md
```

## Deployment on Oracle Cloud VPS

### 1. Build the Application

```bash
./gradlew clean build -x test
```

### 2. Transfer to VPS

```bash
scp build/libs/portfolio-backend-1.0.0.jar user@your-vps-ip:/opt/portfolio-backend/
```

### 3. Create Systemd Service

Create `/etc/systemd/system/portfolio-backend.service`:

```ini
[Unit]
Description=Portfolio Backend Service
After=network.target

[Service]
Type=simple
User=your-user
WorkingDirectory=/opt/portfolio-backend
ExecStart=/usr/bin/java -jar /opt/portfolio-backend/portfolio-backend-1.0.0.jar --spring.profiles.active=prod
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

### 4. Enable and Start Service

```bash
sudo systemctl daemon-reload
sudo systemctl enable portfolio-backend
sudo systemctl start portfolio-backend
sudo systemctl status portfolio-backend
```

### 5. Configure Nginx (for api.domain.com)

Create `/etc/nginx/sites-available/api.domain.com`:

```nginx
server {
    listen 80;
    server_name api.domain.com;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Enable and restart:
```bash
sudo ln -s /etc/nginx/sites-available/api.domain.com /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### 6. SSL Certificate (Let's Encrypt)

```bash
sudo certbot --nginx -d api.domain.com
```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `POSTGRES_URL` | PostgreSQL connection URL | `jdbc:postgresql://localhost:5432/portfolioDb` |
| `POSTGRES_USERNAME` | PostgreSQL username | `postgres` |
| `POSTGRES_PASSWORD` | PostgreSQL password | `postgres` |
| `MONGODB_URI` | MongoDB connection URI | `mongodb://localhost:27017/portfolioDb` |
| `MONGODB_DATABASE` | MongoDB database name | `portfolioDb` |
| `SERVER_PORT` | Server port | `8080` |
| `JPA_DDL_AUTO` | JPA DDL mode | `validate` |
| `JPA_SHOW_SQL` | Show SQL queries | `false` |

## Docker

### Option A: Docker Compose (recommended)

This starts the backend + PostgreSQL + MongoDB:

```bash
docker compose up --build
```

API will be available at:
- `GET http://localhost:8080/v1/health`
- `GET http://localhost:8080/v2/health`

To stop and remove containers (keeps DB volumes):

```bash
docker compose down
```

To also remove DB volumes:

```bash
docker compose down -v
```

### Option B: Build and run only the backend container

Build:

```bash
docker build -t portfolio-backend .
```

Run (pointing to external DB hosts):

```bash
docker run --rm -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=dev \
  -e POSTGRES_URL=jdbc:postgresql://localhost:5432/portfolioDb \
  -e POSTGRES_USERNAME=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e MONGODB_URI=mongodb://localhost:27017/portfolioDb \
  -e MONGODB_DATABASE=portfolioDb \
  portfolio-backend
```

Run without databases (health endpoint only):

```bash
docker run --rm -p 8080:8080 \
  -e APP_DATABASES_ENABLED=false \
  portfolio-backend
```

## Next Steps

- [ ] Add authentication/authorization (JWT)
- [ ] Implement Projects API endpoints
- [ ] Implement Blogs API endpoints
- [ ] Implement Resume API endpoints
- [ ] Add API documentation (Swagger/OpenAPI)
- [ ] Add unit and integration tests
- [ ] Set up CI/CD pipeline

## License

MIT
