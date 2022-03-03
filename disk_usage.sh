export OS_AUTH_TYPE=v3applicationcredential
export OS_AUTH_IDENTITY_API_VERSION=3
set -a
source project/$1
set +a
NODES=$(openstack server list -f csv -c Name --quote none |tail -n +2)

for node in $NODES ; do
    disks=$(openstack server show $node -f yaml -c volumes_attached |grep -v volumes_attached |awk '{print $3}')
    
    echo "$node:"
    for disk in $disks ; do 
        datetime=$(openstack volume show $disk -f value -c created_at)
        date=$(echo "$datetime" |sed 's/T.*//g')
        time=$(echo "$datetime" |sed 's/.*T//g')
        size=$(openstack volume show $disk -f value -c size)
        type=$(openstack volume show $disk -f value -c type)
        tags=$(openstack volume show $disk -f yaml -c properties |grep -v properties)
        echo "  ${date}T${time}:"
        echo "    id: $disk"
        echo "    date: $date"
        echo "    time: $time"
        echo "    usage_type: storage"
        echo "    usage: $size"
        echo "    unit: GB"
        echo "    type: $type"
        echo "    tags:"
        while read t ; do
            echo "      $t"
        done <<< "$tags"
    done
done
