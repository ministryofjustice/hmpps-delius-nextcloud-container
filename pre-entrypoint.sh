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

su -s /bin/bash www-data -c "php occ config:import /var/www/html/config/config.json"

# Execute the original entrypoint with its arguments
exec /entrypoint.sh "$@"
