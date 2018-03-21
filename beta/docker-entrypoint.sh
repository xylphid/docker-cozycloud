#!/bin/sh

echo "Initialize cozy-core"

# Initialize Database
until curl --fail --silent ${COZY_COUCHDB_URL}; do
	echo "Database is unreachable !"
	echo "Will try in 10 seconds ..."
	sleep 10
done
curl --fail --silent -X PUT ${COZY_COUCHDB_URL}/_users
curl --fail --silent -X PUT ${COZY_COUCHDB_URL}/_replicator
curl --fail --silent -X PUT ${COZY_COUCHDB_URL}/_global_changes

# Run server
echo "Starting daemon ..."
cozy-stack serve --config /etc/cozy/cozy.yml >> /dev/stdout 2>> /dev/stderr

sleep 10

# Create instance and install applications
if [[ $(cozy-stack instances ls | grep ${COZY_DOMAIN} | wc -l) = 0 ]]; then
	echo "Create new instance :"
	echo "  Name : ${COZY_DOMAIN}"
	echo "  Applications : ${COZY_APPS}"
	cozy-stack instances add --host 0.0.0.0 --apps ${COZY_APPS} --passphrase ${COZY_ADMIN_PASSPHRASE} ${COZY_DOMAIN}
else
	echo "---"
	echo "Instance for ${COZY_DOMAIN} is already installed"
	echo "---"
fi

# Monitor logs
#rsyslogd -n
tail -f /dev/stdout /dev/stderr