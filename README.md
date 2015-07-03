Dockerfile - HAProxy
=====================
#### - Run
```sh
root@ruo91:~# docker run -d --name="haproxy" -h "haproxy" -p 8080:80 ruo91/haproxy
```
or

#### - Build
```sh
root@ruo91:~# docker build --rm -t haproxy https://github.com/ruo91/docker-haproxy.git
```

#### - Run
```
root@ruo91:~# docker run -d --name="haproxy" -h "haproxy" -p 8080:80 haproxy
```
#### - Reverse proxy settings of Nginx
```sh
root@ruo91:~# nano /etc/nginx/nginx.conf
```

```sh
http {
.............
...................
.......................
# HAProxy status
server {
    listen  80;
    server_name haproxy.yongbok.net;

    location / {
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Server $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_pass http://localhost:8080;
        client_max_body_size 10M;
    }
}
.......................
...................
.............
}
```

```sh
root@ruo91:~# nginx -t 
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
root@ruo91:~# nginx -s reload
```
#### - HAProxy Status
![Status][0]

Thanks. :-)
[0]: http://cdn.yongbok.net/ruo91/img/docker/haproxy/haproxy.png