#!/bin/sh -e

# Generate configuration file
cat << EOF > settings.ini
[html]
page_title = ${PAGE_TITLE:-Change your password on example.org}

[server]
server = auto
host = ${HOST_ADDRESS:-0.0.0.0}
port = ${HTTP_PORT:-8080}

[ldap:0]
host = ${LDAP_HOST:-localhost}
port = ${LDAP_PORT:-636}
use_ssl = ${USE_SSL:-true}
base = ${LDAP_BASE:-ou=People,dc=example,dc=org}
search_filter = ${LDAP_SEARCH_FILTER:-uid={uid\}}
EOF

# AD Section if present
if [ "x${AD_DOMAIN}" != "x" ]; then
cat << EOF >> settings.ini
type = ad
ad_domain = ${AD_DOMAIN}
EOF
fi

# Handle start of app server
if [ "run" = "run" ]; then

    echo "Configuration file:"
    echo
    cat settings.ini
    echo 

    # Debug start
    if [ "${DEBUG}" = "true" ]; then
        exec python3 app.py
    fi

    # Start normally
    exec waitress-serve --listen=*:${HTTP_PORT:-8080} app:application
fi

# Start all other commands
exec $@