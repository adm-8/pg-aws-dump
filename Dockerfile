FROM --platform=linux/amd64 ubuntu:24.04

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    unzip \
    postgresql-client \
    python3 \
    python3-pip \
    libc6 && \ 
    rm -rf /var/lib/apt/lists/*

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Debugging step (optional)
RUN ls -l /lib64/ld-linux-x86-64.so.2 || true

RUN aws --version && pg_dump --version

COPY ./pg-aws-dump.sh /app

CMD ["bash", "pg-aws-dump.sh"]
