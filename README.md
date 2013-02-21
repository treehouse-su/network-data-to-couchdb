This is a little script for using couchdb as a storage for server and local network data.

in Debian/Ubuntu use command
echo "*/5 * * * * root /bin/bash /root/network-data-to-couchdb/cron.sh" > /etc/cron.d/network-data-to-couchdb
