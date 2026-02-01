# syntax=docker/dockerfile:1

FROM eclipse-temurin:17-jdk-jammy AS build
WORKDIR /app

# Copy Gradle wrapper and configuration
COPY gradle gradle
COPY gradlew build.gradle.kts settings.gradle.kts ./

# Cache dependencies
RUN ./gradlew dependencies --no-daemon

# Build application
COPY src ./src
RUN ./gradlew clean build -x test --no-daemon

FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Run as non-root user
RUN apt-get update \
  && apt-get install -y --no-install-recommends ca-certificates curl \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -r -u 10001 -g root app

COPY --from=build /app/build/libs/*.jar /app/app.jar

ENV SERVER_PORT=8080
EXPOSE 8080

HEALTHCHECK --interval=10s --timeout=3s --start-period=20s --retries=10 \
  CMD curl -fsS "http://localhost:${SERVER_PORT}/v1/health" | grep -Eq '"status"[[:space:]]*:[[:space:]]*"UP"' || exit 1

USER app
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
