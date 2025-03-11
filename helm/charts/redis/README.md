## Chart info

Under `Chart.yaml` keywords section we hold information about Redis version  
If you want to check that one use bellow commands  

1. Run this image locally as  
```
docker run --name redis --rm -it -p 6379:6379 redis:alpine
```
2. Connet over `redis-cli` tool  
```
redis-cli INFO server
```
3. If want to see if Redis work use
- connect
```
redis-cli
```
- ping
```
127.0.0.1:6379> ping
PONG
```
