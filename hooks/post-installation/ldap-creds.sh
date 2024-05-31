set -xe

LDAP_PASSWORD=$(aws secretsmanager get-secret-value --secret-id ${LDAP_PASSWORD_SECRET_ARN} --query SecretString --output text)

cd /var/www/html/
php occ ldap:set-config s01 ldapAgentPassword ${LDAP_PASSWORD}
