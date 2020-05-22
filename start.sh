#!/bin/sh

cat << EOF > /etc/letsencrypt/cli.ini
staging = ${LETSENCRYPT_STAGING:-false}

agree-tos = true
non-interactive = true

rsa-key-size = ${LETSENCRYPT_KEY_SIZE:-4096}

dns-cloudflare = true
dns-cloudflare-credentials /run/secrets/cloudflare-credentials
EOF

if [ -n "${LETSENCRYPT_EMAIL}" ]; then
  echo "email = ${LETSENCRYPT_EMAIL}" >> /etc/letsencrypt/cli.ini
fi

for HOOK in /etc/letsencrypt/renewal-hooks/pre/*; do
  [ -f "${HOOK}" ] || continue
  sh "${HOOK}"
done

for DOMAIN in ${LETSENCRYPT_DOMAINS} ; do
  certbot certonly --domains ${DOMAIN}
done

for HOOK in /etc/letsencrypt/renewal-hooks/post/*; do
  [ -f "${HOOK}" ] || continue
  sh "${HOOK}"
done

echo "${LETSENCRYPT_RENEWAL_INTERVAL:-0 7,19 * * *} certbot renew" | crontab -

crond -f
