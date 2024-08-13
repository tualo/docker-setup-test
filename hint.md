docker build --platform linux/x86_64 -t installs .
docker rm install_test 
docker run \
    --platform linux/x86_64 \
    -p 8080:80 \
    -v /Users/thomashoffmann/Documents/Projects/Docker/to/asset/:/root/scripts/ \
    -v /Users/thomashoffmann/Documents/Projects/Docker/to/asset/:/home/webuser/scripts/ \
    --name install_test \
    -e databasename=db \
    -e package=onlinevote \
    -d installs
    