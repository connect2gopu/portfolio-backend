package com.portfolio.config;

import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;

@Configuration
public class DatabaseConfig {

    @Configuration
    @ConditionalOnProperty(
        name = "app.databases.enabled",
        havingValue = "true",
        matchIfMissing = true
    )
    @EnableJpaRepositories(basePackages = "com.portfolio.repository.sql")
    static class JpaConfig {
        // JPA repositories will only be enabled when app.databases.enabled=true (default: true)
    }

    @Configuration
    @ConditionalOnProperty(
        name = "app.databases.enabled",
        havingValue = "true",
        matchIfMissing = true
    )
    @EnableMongoRepositories(basePackages = "com.portfolio.repository.nosql")
    static class MongoConfig {
        // MongoDB repositories will only be enabled when app.databases.enabled=true (default: true)
    }
}
