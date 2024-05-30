#!/bin/sh

set -xe

echo "Pre-entrypoint script"
# cd /var/www/html
# php occ

# # su -s /bin/bash www-data -c "php /var/www/html/occ"
if [ -z "$S3_BUCKET_CONFIG" ]; then
    echo "S3_BUCKET_CONFIG is not set. will not copy config from S3."
else
    echo "S3_BUCKET_CONFIG is set to ${S3_BUCKET_CONFIG}"
    aws s3 cp s3://${S3_BUCKET_CONFIG}/ /var/www/html/config/ --recursive
fi

# load config from s3 into nextcloud
chown -R www-data:www-data /var/www/html/config

# ignore failure of config:import as it will fail if nextcloud is not installed yet - which is the case during the first run and we have a post-installation hook script for that
su -s /bin/bash www-data -c "php occ config:import /var/www/html/config/config.json" || true

# Execute the original entrypoint with its arguments
exec /entrypoint.sh "$@"
