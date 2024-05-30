set -xe

if [ -z "$S3_BUCKET_CONFIG" ]; then
    echo "S3_BUCKET_CONFIG is not set. will not copy config from S3."
else
    echo "S3_BUCKET_CONFIG is set to ${S3_BUCKET_CONFIG}"
    aws s3 cp s3://${S3_BUCKET_CONFIG}/ /var/www/html/config/ --recursive
fi
