NODES=$(openstack server list -f csv -c Name --quote none |tail -n +2)

for node in $NODES ; do

    USAGE=$(openstack server event list $node -f csv -c Action -c "Start Time" --quote none --sort-ascending --sort-column "Start Time")
    USAGE_NO_HEAD=$(echo "$USAGE" |tail -n +2)

    flavor=$(openstack server show $node -f value -c flavor |sed 's/ (.*//g')
    tags=$(openstack server show $node -f yaml -c properties |grep -v properties)

    # TODO: Add Cores, RAM, etc to output
    #FLAVOR_SPECS=$(openstack server show $node --os-compute-api-version 2.47 -f shell -c flavor)

    # Create YAML
    echo "$node:"
    while read l ; do
        event=$(echo "$l" |awk -F "," '{print $1}')
        date=$(echo "$l" |awk -F "," '{print $2}' |sed 's/T.*//g')
        time=$(echo "$l" |awk -F "," '{print $2}' |sed 's/.*T//g')
        echo "  ${date}T${time}:"
        echo "    usage_type: instance_usage"
        echo "    event: $event"
        echo "    date: '$date'"
        echo "    time: '$time'"
        echo "    type: $flavor" 
        echo "    tags:"
        while read t ; do
            echo "      $t"
        done <<< $tags

    done <<< $USAGE_NO_HEAD

done
