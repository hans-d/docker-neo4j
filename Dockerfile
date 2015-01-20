## Neo4J dependency: dockerfile/java
## get java from trusted build
## Based on neo4j docker from Tiago Pires, tiago-a-pires@ptinovacao.pt

FROM dockerfile/java:openjdk-7-jdk
MAINTAINER Hans Donner

RUN wget -O - http://debian.neo4j.org/neotechnology.gpg.key | apt-key add - ; \
    echo 'deb http://debian.neo4j.org/repo stable/' > /etc/apt/sources.list.d/neo4j.list ; \
    apt-get update ; apt-get install neo4j-enterprise -y ; \
    apt-get clean

ADD launch.sh /
RUN chmod +x /launch.sh

VOLUME /var/lib/neo4j/data
VOLUME /var/lib/neo4j/conf
EXPOSE 7474

CMD ["/bin/bash", "-c", "/launch.sh"]
