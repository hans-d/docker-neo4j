FROM java:openjdk-8-jdk
MAINTAINER Hans Donner <hans.donner@pobox.com>

ENV NEO4J_VERSION=2.2.5

RUN wget -O - http://debian.neo4j.org/neotechnology.gpg.key | apt-key add - ; \
    echo 'deb http://debian.neo4j.org/repo stable/' > /etc/apt/sources.list.d/neo4j.list ; \
    apt-get update ; apt-get install neo4j=$NEO4J_VERSION -y ; \
    apt-get clean

ADD launch.sh /
RUN chmod +x /launch.sh

VOLUME /var/lib/neo4j/data

EXPOSE 7474
EXPOSE 1337

CMD ["/bin/bash", "-c", "/launch.sh"]