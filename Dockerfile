FROM certbot/dns-cloudflare:v1.4.0

COPY hook-post_combine-fullchain-and-key.sh /renewal-hooks/post/
COPY entrypoint.sh /

ENTRYPOINT [ "sh", "-c" ]

CMD [ "/entrypoint.sh" ]
