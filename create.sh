docker stop briefwahl
docker rm briefwahl 
docker rmi dev-environment
docker build -t dev-environment .
docker run \
    --name briefwahl \
    --net dev-network \
    -p 8080:80 \
    -d dev-environment
