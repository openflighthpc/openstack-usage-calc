## Setup (Sinatra)

- Presume RVM installed with 3.0.0
- Install dependencies
  ```shell
  gem install sinatra puma
  ```
- Run Server
  ```shell
  rackup -o 0.0.0.0
  ```

## Setup (OpenStack Credentials)

- Create an auth script for the project
```
cat << EOF > projects/$PROJECT
OS_AUTH_URL=http://$KEYSTONE_IP:$KEYSTONE_PORT
OS_APPLICATION_CREDENTIAL_ID=$CREDENTIAL_ID
OS_APPLICATION_CREDENTIAL_SECRET=$CREDENTIAL_SECRET
EOF
```

## Usage

- Get usage for VMs and disks in a project
```
curl http://$IP:$PORT/usage/$PROJECT
```

- Get instance power status
```
curl http://$IP:$PORT/status/$PROJECT/$NODE
```

- Turn instance on
```
curl http://$IP:$PORT/on/$PROJECT/$NODE
```

- Turn instance off
```
curl http://$IP:$PORT/off/$PROJECT/$NODE
```

- Get CPU utilisation percentage for the last 20 minutes 
```
curl http://$IP:$PORT/monitor/$PROJECT/$NODE
```

