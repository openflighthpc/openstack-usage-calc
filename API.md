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

## Usage

- Create an auth script for the project
```
cat << EOF > projects/$PROJECT
OS_AUTH_URL=http://$KEYSTONE_IP:$KEYSTONE_PORT
OS_APPLICATION_CREDENTIAL_ID=$CREDENTIAL_ID
OS_APPLICATION_CREDENTIAL_SECRET=$CREDENTIAL_SECRET
EOF
```

- Call API server for usage 
```
curl http://$IP:$PORT/usage/$PROJECT
```

