FROM certbot/dns-cloudflare:v1.4.0

COPY hook-post_combine-fullchain-and-key.sh /renewal-hooks/post/
COPY start.sh /

ENTRYPOINT [ "sh", "-c" ]

CMD [ "/start.sh" ]
