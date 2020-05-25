# xSystems Let's Encrypt DNS Cloudflare

> Service to obtain certificates for specified, Cloudflare managed, domains using Let's Encrypt

## Usage

### Run

Create a Cloudflare credentials file as described in the [documentation of the certbot-dns-cloudflare plugin][certbot-dns-cloudflare].

When running a container of this image you **must** mount the credentials file at `/run/secrets/cloudflare-credentials` inside the container.
This can either be achieved using Docker Volumes or Docker Secrets.

Also, when running a container of this image you **must** specify the environment variables `LETSENCRYPT_DOMAINS` and `LETSENCRYPT_EMAIL`.

All available environment variables are:

| Environment Variable          | Default Value | Required  | Description                                                           |
| :---------------------------- | :------------ | :-------: | :-------------------------------------------------------------------- |
| LETSENCRYPT_DOMAINS           |               |     ✔     | A **space separated** list of domains your machine can be reached at  |
| LETSENCRYPT_EMAIL             |               |     ✔     | An email for error reporting                                          |
| LETSENCRYPT_RENEWAL_INTERVAL  | 0 7,19 * * *  |           | How often should be checked for certificate expiry                    |
| LETSENCRYPT_STAGING           | false         |           | Enable staging mode i.e. issue **fake** certificates                  |
| LETSENCRYPT_KEY_SIZE          | 4096          |           | Size of the RSA key                                                   |

### Files

What certificate and key files are created and where is described [in this section  of the Certbot documentation][letsencrypt-files].

In addition a container of this image also creates a file called `/etc/letsencrypt/full/<DOMAIN>.pem` per domain, containing all certificates and the key.
This is done to facilitate services, like HAProxy, that require the intermediate certificate; certificate; and key, to be in one file.


## Build the Image

Run [build.sh](build.sh) to build an image of the current codebase state with tag `latest`.


## Extend the Image

When extending the image and wanting to add `deploy`, `post`, or `pre` renewal hooks as explained [here][letsencrypt-renewal-hooks],
then `COPY` them to the `/renewal-hooks` directory and NOT the `/etc/letsencrypt/renewal-hooks` directory.
The directory `/etc/letsencrypt` is marked as `VOLUME` in the base image.
Meaning that at run-time a volume will be mounted at that path and (except for the first) mask all changes made to files copied to that path during build, e.g. renewal hooks.


## Release the Image

1. Make sure you are allowed to push to the `xsystems` repository on Docker Hub e.g. by doing: `docker login`
2. Set the `VERSION` environment variable to the version that needs to be released.
3. Optionally, set the `COMMIT` environment variable to the hash of the Git commit that needs to be released. It defaults to the latest commit.
4. Run [release.sh](release.sh).

Example release statement:

```sh
VERSION=1.3.42 ./release.sh
```


[certbot-dns-cloudflare]: https://certbot-dns-cloudflare.readthedocs.io/en/stable/ "Documentation of the certbot-dns-cloudflare plugin"
[letsencrypt-files]: https://certbot.eff.org/docs/using.html#where-are-my-certificates "Files created by Let's Encrypt"
[letsencrypt-renewal-hooks]: https://certbot.eff.org/docs/using.html#renewing-certificates "Renewal Hooks"
