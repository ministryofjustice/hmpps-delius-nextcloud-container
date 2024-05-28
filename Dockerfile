FROM nextcloud:latest

RUN apt-get update && apt-get install -y \
    jq \
    unzip \
    curl && \
    apt clean

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

COPY ./pre-entrypoint.sh /pre-entrypoint.sh

RUN chmod +x /pre-entrypoint.sh

ENTRYPOINT ["/pre-entrypoint.sh"]
CMD ["apache2-foreground"]
