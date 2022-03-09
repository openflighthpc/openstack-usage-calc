export OS_AUTH_TYPE=v3applicationcredential
export OS_AUTH_IDENTITY_API_VERSION=3
set -a
source project/$1
set +a

node=$2

# Check node exists
if ! openstack server show $node >> /dev/null 2>&1 ; then
    echo "NODE NOT FOUND"
    exit 1
fi
openstack server start $node
