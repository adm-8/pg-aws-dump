```
docker build -t adm8/pg-dump-aws:pg17 .
docker push adm8/pg-dump-aws:pg17
```

```
docker run -it --rm --env-file .env adm8/pg-dump-aws:pg17
```

```
docker run -it --rm adm8/pg-dump-aws bash 
```