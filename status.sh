export OS_AUTH_TYPE=v3applicationcredential
export OS_AUTH_IDENTITY_API_VERSION=3
set -a
source project/$1
set +a

node=$2

openstack server show $node -c status -f value
