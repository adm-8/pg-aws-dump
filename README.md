```
docker build -t adm8/pg-dump-aws:latest .
```

```
docker run -it --rm --env-file .env adm8/pg-dump-aws
```

```
docker run -it --rm adm8/pg-dump-aws bash 
```