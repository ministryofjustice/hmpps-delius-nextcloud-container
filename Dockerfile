FROM nextcloud:latest

ARG s3_bucket

RUN s3 cp s3://$s3_bucket/config/ /var/www/config/ --recursive
RUN s3 cp s3://$s3_bucket/html/ /var/www/html/ --recursive
RUN s3 cp s3://$s3_bucket/custom_apps/ /var/www/custom_apps/ --recursive
RUN s3 cp s3://$s3_bucket/themes/ /var/www/themes/ --recursive
