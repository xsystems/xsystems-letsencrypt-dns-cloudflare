#!/bin/sh

if [ -z "${VERSION}" ]; then
  echo "The VERSION environment variable is NOT set, but is required."
  exit
fi

COMMIT=${COMMIT:-`git rev-parse HEAD`}

git tag --annotate --message "Release ${VERSION}" ${VERSION} ${COMMIT}
git push origin ${VERSION}

docker build --tag xsystems/letsencrypt-dns-cloudflare:${VERSION} "https://github.com/xsystems/xsystems-letsencrypt-dns-cloudflare.git#${COMMIT}"
docker tag xsystems/letsencrypt-dns-cloudflare:${VERSION} xsystems/letsencrypt-dns-cloudflare:latest

docker push xsystems/letsencrypt-dns-cloudflare:${VERSION}
docker push xsystems/letsencrypt-dns-cloudflare:latest
