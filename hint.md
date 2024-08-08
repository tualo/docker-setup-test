docker build --platform linux/x86_64 -t installs .
docker rm install_test 
docker run \
    --platform linux/x86_64 \
    -p 8080:80 \
    -v /Users/thomashoffmann/Documents/Projects/Docker/to/asset/:/root/scripts/ \
    --name install_test \
    -d installs
    