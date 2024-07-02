#FROM nextcloud:29.0.0-apache
FROM nextcloud:21-apache

RUN apt-get update && apt-get install -y \
    unzip \
    curl && \
    apt clean

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

COPY ./hooks/ /docker-entrypoint-hooks.d
RUN chmod +x -R /docker-entrypoint-hooks.d
RUN chown -R www-data:www-data /var/www/

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
