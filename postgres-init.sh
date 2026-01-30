#!/bin/sh
set -e

# One admin user (postgres, from image); app user for portfolioDb - same pattern as Mongo
APP_PASS="${POSTGRES_APP_PASSWORD:-portfolioDbPass}"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<EOSQL
  CREATE DATABASE "portfolioDb";
  CREATE USER "portfolioDbUser" WITH PASSWORD '$APP_PASS';
  GRANT CONNECT ON DATABASE "portfolioDb" TO "portfolioDbUser";
  GRANT ALL PRIVILEGES ON DATABASE "portfolioDb" TO "portfolioDbUser";
EOSQL

# Schema privileges for portfolioDbUser
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "portfolioDb" <<EOSQL
  GRANT ALL ON SCHEMA public TO "portfolioDbUser";
  ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO "portfolioDbUser";
EOSQL
