#!/bin/sh

set -xe

echo "Pre-entrypoint script"
aws s3 cp s3://${S3_BUCKET}/ /var/www/html/config/ --recursive

# Execute the original entrypoint with its arguments
exec /entrypoint.sh "$@"
