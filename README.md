```
docker build -t adm8/pg-dump-aws:pg17 .
docker push adm8/pg-dump-aws:pg17
```

```
docker run -it --rm --env-file .env adm8/pg-dump-aws:pg17
```

```
docker run -it --rm --env-file .env adm8/pg-dump-aws bash 
```


# To restore DB:

```
gunzip -c $BACKUP_FILE_PATH | psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB

```

```
docker run -it --rm --env-file .env \
    -v ~/Downloads/2025-05-13_19-54-56.pg_dump.gz:/tmp/backup.gz \
    adm8/pg-dump-aws bash

gunzip -c /tmp/backup.gz | psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB
```

```
docker run -it --rm --env-file .env \
    -v ~/Downloads/2025-05-13_19-54-56.pg_dump.gz:/tmp/backup.gz \
    adm8/pg-dump-aws \
    gunzip -c /tmp/backup.gz | psql -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER -d $POSTGRES_DB
```