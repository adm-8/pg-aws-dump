#!/bin/bash
set -o errexit -o pipefail -o nounset

# If debug - print ENV vars
if [ "$DEBUG_MODE" = "true" ]; then
    env
fi

### START CHECKS

# Check AWS_REGION
if [ -z "${AWS_REGION+isset}" ]; then
    echo "AWS_REGION is set and non-empty"
    exit 1
fi

# Check AWS_ENDPOINT_URL
if [ -z "${AWS_ENDPOINT_URL+isset}" ]; then
    echo "AWS_ENDPOINT_URL is set and non-empty"
    exit 1
fi

# Check AWS_ACCESS_KEY_ID
if [ -z "${AWS_ACCESS_KEY_ID+isset}" ]; then
    echo "AWS_ACCESS_KEY_ID is set and non-empty"
    exit 1
fi

# Check AWS_SECRET_ACCESS_KEY
if [ -z "${AWS_SECRET_ACCESS_KEY+isset}" ]; then
    echo "AWS_SECRET_ACCESS_KEY is set and non-empty"
    exit 1
fi

# Check AWS_TEMP_DIR_PATH
if [ -z "${AWS_TEMP_DIR_PATH+isset}" ]; then
    echo "AWS_TEMP_DIR_PATH is set and non-empty"
    exit 1
fi

# Check AWS_BUCKET_NAME
if [ -z "${AWS_BUCKET_NAME+isset}" ]; then
    echo "AWS_BUCKET_NAME is set and non-empty"
    exit 1
fi

echo "AWS settings check success!"

### POSTGRES CHECKS

# Check POSTGRES_HOST
if [ -z "${POSTGRES_HOST+isset}" ]; then
    echo "POSTGRES_HOST is set and non-empty"
    exit 1
fi

# Check POSTGRES_PORT
if [ -z "${POSTGRES_PORT+isset}" ]; then
    echo "POSTGRES_PORT is set and non-empty"
    exit 1
fi

# Check POSTGRES_DB
if [ -z "${POSTGRES_DB+isset}" ]; then
    echo "POSTGRES_DB is set and non-empty"
    exit 1
fi

# Check POSTGRES_USER
if [ -z "${POSTGRES_USER+isset}" ]; then
    echo "POSTGRES_USER is set and non-empty"
    exit 1
fi

# Check POSTGRES_PASSWORD
if [ -z "${POSTGRES_PASSWORD+isset}" ]; then
    echo "POSTGRES_PASSWORD is set and non-empty"
    exit 1
fi

echo "POSTGRES settings check success!"

### END CHECKS

# Make directories
mkdir -p ~/.aws/
echo "~/.aws/ directory created!"

mkdir -p "$AWS_TEMP_DIR_PATH"
echo "$AWS_TEMP_DIR_PATH directory created!"

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
    export BACKUP_FILE_PATH="$AWS_TEMP_DIR_PATH/$CURENT_DT.pg_dump.gz"

    echo "Craeting backup at $CURENT_DT with path $BACKUP_FILE_PATH"
    export PGPASSWORD="$POSTGRES_PASSWORD"

    pg_dump \
        --host="$POSTGRES_HOST" \
        --port="$POSTGRES_PORT" \
        --username="$POSTGRES_USER" \
        --dbname="$POSTGRES_DB" \
        --format=plain \
        | gzip > $BACKUP_FILE_PATH

    aws s3 cp $BACKUP_FILE_PATH "s3://$AWS_BUCKET_NAME/$CURENT_DT/"
    sleep "${SLEEP_SECONDS:-3600}"  # Defaults to 3600 second (one hour) if unset
done

