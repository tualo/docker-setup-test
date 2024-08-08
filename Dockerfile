FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
# apt install php8.0 libapache2-mod-php8.0
RUN apt-get update; \
    apt-get -yq upgrade; \
    apt-get install -y apt-utils; \
    apt-get install -y --no-install-recommends; \
    apt-get install -y wget; \
    apt-get install -y unzip;

RUN mkdir -p /var/www/html/server
RUN mkdir -p /var/www/html/server_setup
RUN mkdir -p /var/sencha
RUN wget https://tualo.de/downloads/SenchaCmd-7.8.0.59-linux-amd64.sh -O /root/SenchaCmd-7.8.0.59-linux-amd64.sh
RUN wget https://tualo.de/downloads/ext-7.8.0.zip -O /root/ext-7.8.0.zip
RUN wget https://tualo.de/downloads/epa-7.8.0.zip -O /root/ext-addons-7.8.0.zip


WORKDIR "/root"
RUN unzip ext-7.8.0.zip; \
    unzip ext-addons-7.8.0.zip; \
    mv ext-7.8.0 /var/sencha/; \
    mv ext-addons-7.8.0 /var/sencha/; \
    cp -r /var/sencha/ext-addons-7.8.0/packages/* /var/sencha/ext-7.8.0/packages/;


RUN apt-get update; \
    apt-get install -y nodejs; \
    apt-get install -y npm;
RUN npm install -g sass

RUN apt-get update; \
    apt-get -yq upgrade; \
    apt-get install -y mariadb-server; \
    apt-get install -y apt-utils; \
    apt-get install -y --no-install-recommends; \
    apt-get install -y apache2; \
    apt-get install -y libapache2-mod-php; \
    apt-get install -y libapache2-mod-rewrite; \
    apt-get install -y php; \
    apt-get install -y composer; \
    apt-get install -y php-mysql; \
    apt-get install -y php-mbstring; \
    apt-get install -y php-json; \
    apt-get install -y php-xml; \
    apt-get install -y php-zip; \
    apt-get install -y php-gd; \
    apt-get install -y php-redis; \
    apt-get install -y php-curl; \
    apt-get install -y composer; \
    a2enmod rewrite; \
    a2enmod headers; \
    a2enmod proxy_http; \
    a2enmod deflate;


RUN apt-get update; \
    apt-get install -y openjdk-8-jre;






COPY asset/composer.json /var/www/html/server_setup/composer.json

RUN mkdir -p /root/scripts
COPY asset/run.sh /root/scripts/run.sh
COPY asset/openssl.cnf /etc/ssl/openssl.cnf
COPY asset/51-lower.cnf /etc/mysql/mariadb.conf.d/51-lower.cnf


WORKDIR "/root"
RUN chmod +x /root/SenchaCmd-7.8.0.59-linux-amd64.sh

# RUN export INSTALL4J_JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64

RUN export _JAVA_OPTIONS="-Xms2048m -Xmx8192m -XX:+AlwaysPreTouch -XX:+TieredCompilation -XX:NewRatio=1 -XX:+UseConcMarkSweepGC -XX:MaxMetaspaceSize=1024m -XX:ParallelGCThreads=2 -XX:ConcGCThreads=2 -XX:MaxTenuringThreshold=15"; \
    /root/SenchaCmd-7.8.0.59-linux-amd64.sh -Dall=true -q -dir /var/sencha/Sencha/Cmd/7.8.0.59; \
    chmod -R 777 /var/sencha;



RUN echo ' ' >> /root/.bashrc
RUN echo 'export PATH="/var/sencha/Sencha/Cmd/7.8.0.59/:$PATH"' >> /root/.bashrc
RUN echo 'export _JAVA_OPTIONS="-Xms2048m -Xmx8192m -XX:+AlwaysPreTouch -XX:+TieredCompilation -XX:NewRatio=1 -XX:+UseConcMarkSweepGC -XX:MaxMetaspaceSize=1024m -XX:ParallelGCThreads=2 -XX:ConcGCThreads=2 -XX:MaxTenuringThreshold=15"' >> /root/.bashrc

COPY asset/000-default.conf /etc/apache2/sites-available/000-default.conf
 
WORKDIR "/var/www/html/server"

EXPOSE 80
CMD ["sh","/root/scripts/run.sh"]
