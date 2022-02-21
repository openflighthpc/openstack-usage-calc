# OpenStack Billing Calculator

## Overview

This repository contains a collection of scripts for identifying usage & billing information for an OpenStack project. Providing the initial proof-of-concept for integration with [flight control](https://github.com/openflighthpc/flight-control).

## Input Data

The following information is required to use these scripts:
- [Application Credentials](https://docs.openstack.org/keystone/xena/user/application_credentials.html)
    - `OS_APPLICATION_CREDENTIAL_ID=ApplicationID`
    - `OS_APPLICATION_CREDENTIAL_SECRET=ApplicationSecret`
- OpenStack CLI Configuration (for using Application Credentials)
    - `OS_AUTH_URL=KeystoneURL`
    - `OS_AUTH_TYPE=v3applicationcredential` (note: `v3applicationcredential` is the literal value of this field)
    - `OS_IDENTITY_API_VERSION=3`

All variables above should be exported to the environment the script is being run from.

## Output

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

## Notes

- The `instance_record.rb` script identifies daily uptime by calculating it from power events. For this reason, the script can only provide data from the initial creation of each node until today and is unable to reduce query/calculation time by only doing it for a specific date or range.

