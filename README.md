# OpenStack Billing Calculator

## Overview

This repository contains a collection of scripts for identifying usage & billing information for an OpenStack project. Providing the initial proof-of-concept for integration with [flight control](https://github.com/openflighthpc/flight-control).

You'll likely need the following additional OpenStack CLI packages (install with `pip`):
- `gnocchiclient`

## Instance Usage Reporting

### Input Data

The following information is required to use these scripts:
- [Application Credentials](https://docs.openstack.org/keystone/xena/user/application_credentials.html)
    - `OS_APPLICATION_CREDENTIAL_ID=ApplicationID`
    - `OS_APPLICATION_CREDENTIAL_SECRET=ApplicationSecret`
- OpenStack CLI Configuration (for using Application Credentials)
    - `OS_PROJECT_NAME=ProjectName`
    - `OS_AUTH_URL=KeystoneURL`
    - `OS_AUTH_TYPE=v3applicationcredential` (note: `v3applicationcredential` is the literal value of this field)
    - `OS_IDENTITY_API_VERSION=3`

Create a config file to contain the CLI configuration variables underneath the `project/` directory. The name of this file will be the project argument to the `instance_recorder.rb` script.

### Output

The output of `instance_recorder.rb` is formatted as follows:
```json
{"YYYY-MM-DD": {
    "NODENAME": {
        "usage": UsageInHours,
        "type": OpenStackFlavor,
        "usage_type": instance_usage,
        "tags": {
            "type": NodeType,
            "compute_group": GroupName
        }
    }
}
```

## Instance Status

### Input

The command requires the project config file name and the node name:
```shell
bash status.sh MyProject cnode01
```

### Output

Returns one of the following:
- `ACTIVE`: Node is up
- `SHUTOFF`: Node is off
- `NODE NOT FOUND`: No such node found in project

## Instance Monitoring

Reference for monitoring with gnocchi - https://stackoverflow.com/a/57386023

### Prerequisites

- Gnocchi/Telemetry Enabled
- CPU Metric Changes (in `/etc/ceilometer/gnocchi_resources.yaml`)
    - Set `archive_policy_name` to `ceilometer-rate-high` (this will enable 60s granularity and max aggregation)

_**Note: The above needs to be true before instance creation**_

To verify that metrics are working as expecting for an instance:
```shell
gnocchi measures show --resource-id=$(openstack server show $NODENAME -c id -f value) cpu --granularity 60 --aggregation rate:mean
```

### Input

The command requires the project config file name and the node name:
```shell
bash instance_monitor.sh MyProject cnode01
```

### Output

This returns the average usage over the last 20 minutes as a percentage of overall CPU to 2 decimal places.

In the event that there are less than 20 data points (e.g. the node has been up for less than 20 minutes) then it will return 100 to ensure node stays up.

## Notes

- The `instance_record.rb` script identifies daily uptime by calculating it from power events. For this reason, the script can only provide data from the initial creation of each node until today and is unable to reduce query/calculation time by only doing it for a specific date or range.
- Instance details can be queried in OpenStack with `openstack flavor list -f json`, prices will then need to be manually added
- Storage cost calculation will require manually setting price-per-gb

