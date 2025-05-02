#!/bin/bash

# Make directories
mkdir -p ~/.aws/
mkdir -p "$AWS_TEMP_DIR_PATH"

# Create AWS config file
cat <<EOF > ~/.aws/config
[default]
region = $AWS_REGION
endpoint_url = $AWS_ENDPOINT_URL
EOF

# Create AWS creadentials file
cat <<EOF > ~/.aws/credentials
[default]
aws_access_key_id = $AWS_ACCESS_KEY_ID
aws_secret_access_key = $AWS_SECRET_ACCESS_KEY
EOF

# endless loop:
while true; do
    # Making backup file:
    export CURENT_DT=$(date +"%Y-%m-%d_%H-%M-%S")
    export BACKUP_FILE_PATH="$AWS_TEMP_DIR_PATH/$CURENT_DT.backup"

    echo "Craeting backup at $CURENT_DT with path $BACKUP_FILE_PATH"
    sleep "${SLEEP_SECONDS:-3600}"  # Defaults to 3600 second (one hour) if unset
done

