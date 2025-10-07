#!/bin/bash

echo "Waiting for Selenium Grid to be ready at selenium:4444..."

while true; do
  STATUS=$(curl -s http://selenium:4444/wd/hub/status | awk '/"ready"/ {print $2}' | tr -d ',')
  if [ "$STATUS" = "true" ]; then
    echo "✅ Selenium Grid is ready!"
    break
  else
    echo "Selenium Grid not ready yet. Retrying in 2 seconds..."
    sleep 2
  fi
done 