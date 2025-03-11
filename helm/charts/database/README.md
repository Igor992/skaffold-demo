## Chart info

Under `Chart.yaml` keywords section we hold information about SQL version  
If you want to check that one use bellow commands  

1. Run this image locally as  
```
docker run --name postgre -e POSTGRES_HOST_AUTH_METHOD=trust --rm -it -p 5432:5432 postgres:15-alpine
```
2. Connet over `psql` tool  
```
psql --host localhost --port 5432 --no-password --username postgres
```
3. Run query  
```
postgres=# SELECT version();
postgres=# SELECT id,vote FROM public.votes;
```
