#!/bin/sh
set -e

echo "Downloading site: ${SITE_URL} into /usr/share/nginx/html..."


rm -rf /usr/share/nginx/html/*

cd /usr/share/nginx/html


wget -E -k -p -nH ${SITE_URL}

echo "Download complete. Starting Nginx."

# # Start Nginx in the foreground
exec nginx -g 'daemon off;'
