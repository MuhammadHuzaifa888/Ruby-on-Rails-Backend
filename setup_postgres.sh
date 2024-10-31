#!/bin/bash

# Start PostgreSQL service
service postgresql start

# Wait for PostgreSQL to start
sleep 5

# Create user and database if they don't exist
su - postgres -c "psql -c \"DO \$\$ BEGIN \
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'Huzaifa') THEN \
      CREATE ROLE Huzaifa WITH LOGIN SUPERUSER PASSWORD 'huzaifa8'; \
   END IF; \
END \$\$;\""

su - postgres -c "psql -c \"DO \$\$ BEGIN \
   IF NOT EXISTS (SELECT FROM pg_database WHERE datname = 'memee_dev') THEN \
      CREATE DATABASE \"memee_dev\" OWNER Huzaifa; \
   END IF; \
END \$\$;\""

# Grant permissions
su - postgres -c "psql -c \"GRANT ALL PRIVILEGES ON DATABASE \"memee_dev\" TO Huzaifa;\""

# Run Rails database setup commands
rails db:create
rails db:migrate

# Start the Rails server
rails server -b 0.0.0.0
