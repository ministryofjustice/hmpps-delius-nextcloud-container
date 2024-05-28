#!/bin/sh

set -xe

echo "Pre-entrypoint script"
aws s3 cp s3://${S3_BUCKET}/ /var/www/html/config/ --recursive

export MYSQL_HOST=$(echo $RDS_SECRET | jq -r .password)
export MYSQL_USER=$(echo $RDS_SECRET | jq -r .username)

# Execute the original entrypoint with its arguments
exec /entrypoint.sh "$@"
