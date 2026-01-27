package com.portfolio.config;

import org.springframework.context.annotation.Configuration;

/**
 * Configuration for API versioning.
 * URL-based versioning is handled by the @RequestMapping annotations
 * in the controller classes (e.g., /v1/health, /v2/health).
 */
@Configuration
public class ApiVersioningConfig {
    // URL-based versioning is handled by controller @RequestMapping paths
    // No additional configuration needed
}
