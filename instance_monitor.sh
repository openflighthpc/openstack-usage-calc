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

ID=$(openstack server show $node -c id -f value)

# Get CPU Util %
## Mean CPU Usage for Period
## Divided by "Granularity in Nanoseconds" (e.g. 60s = 60000000000, 300s = 300000000000) 
## Divided by 100 for percentage
## Ref: https://stackoverflow.com/questions/56216683/openstack-get-vm-cpu-util-with-stein-version
TWENTYMINSAGO=$(date -d '20 minutes ago' '+%FT%T')

gnocchi aggregates --start $TWENTYMINSAGO --granularity 60 '(* (/ (aggregate rate:mean (metric cpu mean)) 60000000000) 100)' id=$ID
