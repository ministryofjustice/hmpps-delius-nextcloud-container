set -xe

if [ -z "$S3_BUCKET_CONFIG" ]; then
    echo "S3_BUCKET_CONFIG is not set. will not copy config from S3."
else
    echo "S3_BUCKET_CONFIG is set to ${S3_BUCKET_CONFIG}"
    aws s3 cp s3://${S3_BUCKET_CONFIG}/ /var/www/html/config/ --recursive
fi

# set ownership of the config directory
chown -R www-data:www-data /var/www/html/config

# import the nextcloud config
cd /var/www/html/
php occ config:import ./config/config.json

LDAP_PASSWORD=$(aws secretsmanager get-secret-value --secret-id ${LDAP_PASSWORD_SECRET_ARN} --query SecretString --output text)

cd /var/www/html/
php occ ldap:set-config s01 ldapAgentPassword ${LDAP_PASSWORD}
