#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e


# Check if Nextcloud is installed
if php occ status | grep -q "installed: true"; then
    echo "Nextcloud is already installed - running startup scripts"

    if [ -z "$S3_BUCKET_CONFIG" ]; then
        echo "S3_BUCKET_CONFIG is not set. Will not copy config from S3."
    else
        echo "S3_BUCKET_CONFIG is set to ${S3_BUCKET_CONFIG}"
        aws s3 cp "s3://${S3_BUCKET_CONFIG}/" /var/www/html/config/ --recursive
    fi

    # Set ownership of the config directory
    chown -R www-data:www-data /var/www/

    # Import the Nextcloud config
    cd /var/www/html/
    php occ config:import ./config/config.json

    # Check if LDAP_PASSWORD_SECRET_ARN is set
    if [ -z "$LDAP_PASSWORD_SECRET_ARN" ]; then
        echo "LDAP_PASSWORD_SECRET_ARN is not set. Aborting."
    else
      LDAP_PASSWORD=$(aws secretsmanager get-secret-value --secret-id "${LDAP_PASSWORD_SECRET_ARN}" --query SecretString --output text)
    fi

    # Set LDAP password
    php occ ldap:set-config s01 ldapAgentPassword "${LDAP_PASSWORD}" || true
else
    echo "Nextcloud is not installed yet. Skipping startup scripts."
    echo "pre/post installation scripts will run after installation instead."
fi
