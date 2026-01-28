# syntax=docker/dockerfile:1

FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Cache dependencies first
COPY pom.xml .
RUN mvn -q -DskipTests dependency:go-offline

# Build application
COPY src ./src
RUN mvn -q -DskipTests package

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Run as non-root user
RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates curl \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -r -u 10001 -g root app

COPY --from=build /app/target/*.jar /app/app.jar

ENV SERVER_PORT=8080
EXPOSE 8080

HEALTHCHECK --interval=10s --timeout=3s --start-period=20s --retries=10 \
  CMD curl -fsS "http://localhost:${SERVER_PORT}/v1/health" | grep -Eq '"status"[[:space:]]*:[[:space:]]*"UP"' || exit 1

USER app
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
