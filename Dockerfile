FROM --platform=linux/amd64 ubuntu:24.04

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and setup repositories
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common && \
    curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/postgresql.gpg arch=amd64] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/postgresql.list && \
    curl -sSL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip

# Install postgresql-client-17
RUN apt-get update && \
    apt-get install -y postgresql-client-17 && \
    rm -rf /var/lib/apt/lists/*

# Install AWS CLI
RUN apt-get install -y unzip && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Cleanup
RUN apt-get autoremove -y && \
    apt-get clean

RUN aws --version && pg_dump --version

COPY ./pg-aws-dump.sh /app

CMD ["bash", "pg-aws-dump.sh"]
