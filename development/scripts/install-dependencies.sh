#!/bin/bash

# use the correct version of node
nvm use 18

# initialise frappe bench
bench init --skip-redis-config-generation frappe-bench
cd frappe-bench

# set the config
bench set-config -g db_host mariadb
bench set-config -g redis_cache redis://redis:6379  # For production redis://redis-cache:6379
bench set-config -g redis_queue redis://redis:6379  # For production redis://redis-queue:6379
bench set-config -g redis_socketio redis://redis:6379  # For production redis://redis-socketio:6379

# set the config to developer mode
bench set-config -g developer_mode true

# Automatically create a new site
bench new-site --no-mariadb-socket development.localhost

# Install ERPNEXT
bench get-app --branch develop --resolve-deps erpnext
bench --site development.localhost install-app erpnext

#Install HRMS
bench get-app hrms
bench --site development.localhost install-app hrms

#Install Ecommerce Integrations
bench get-app ecommerce_integrations --branch develop --resolve-deps
bench --site development.localhost install-app ecommerce_integrations

#Install Wiki
bench get-app https://github.com/frappe/wiki
bench --site development.localhost install-app wiki