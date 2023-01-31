#!/bin/bash

echo "Starting web server..."
pm2 start /usr/src/app/app.js --no-daemon
