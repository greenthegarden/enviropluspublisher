#! /usr/bin/env bash

# Update bind address for Gunicorn
sed 's/os.getenv("PORT", "80")/os.getenv("PORT", "8080")/' /gunicorn_conf.py > /app/gunicorn_conf.py

# Run supervisor
supervisor -c /supervisord.conf
