#!/bin/bash
set -e

echo "Starting web server..."

pm2-runtime /usr/src/app/app.js
