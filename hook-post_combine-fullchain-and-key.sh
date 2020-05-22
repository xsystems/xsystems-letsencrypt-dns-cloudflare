#!/bin/sh

set -e

for DOMAIN in ${LETSENCRYPT_DOMAINS} ; do
  echo "Creating /etc/letsencrypt/live/${DOMAIN}/full.pem"
  cat /etc/letsencrypt/live/${DOMAIN}/fullchain.pem \
      /etc/letsencrypt/live/${DOMAIN}/privkey.pem \
      > /etc/letsencrypt/live/${DOMAIN}/full.pem
done
