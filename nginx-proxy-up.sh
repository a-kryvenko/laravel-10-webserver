docker network create nginx-proxy-network

docker run --detach \
    --rm \
    --name nginx-proxy \
    --publish 80:80 \
    --publish 443:443 \
    --net nginx-proxy-network \
    --env DEFAULT_ROOT="503 $(pwd)/maintenance.html" \
    --volume $(pwd)/.docker/nginx-proxy/custom-proxy-config.conf:/etc/nginx/conf.d/custom-proxy-config.conf \
    --volume certs:/etc/nginx/certs \
    --volume vhost:/etc/nginx/vhost.d \
    --volume html:/usr/share/nginx/html \
    --volume /var/run/docker.sock:/tmp/docker.sock:ro \
    nginxproxy/nginx-proxy:alpine

docker run --detach \
    --rm \
    --name nginx-proxy-acme \
    --net nginx-proxy-network \
    --volumes-from nginx-proxy \
    --volume /var/run/docker.sock:/var/run/docker.sock:ro \
    --volume acme:/etc/acme.sh \
    --env "DEFAULT_EMAIL=mr.blackkrab@gmail.com" \
    nginxproxy/acme-companion
