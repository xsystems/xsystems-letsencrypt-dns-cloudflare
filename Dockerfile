FROM certbot/dns-cloudflare:v1.4.0

COPY hook-post_combine-fullchain-and-key.sh /etc/letsencrypt/renewal-hooks/post/
COPY start.sh /

ENTRYPOINT [ "sh", "-c" ]

CMD [ "/start.sh" ]
