neo4j
=====

Neo4j is a highly scalable, robust (fully ACID) native graph database. Neo4j is used in mission-critical apps by thousands of leading, startups, enterprises, and governments around the world.

With the Dockerfile on repository you've a docker neo4j community edition image ready to go.

### Setup

1. Execute this command:

	`docker run -i -t -d -privileged -p 7474:7474 hansd/neo4j`

2. Access to http://localhost:7474 with your browser.


### Versions/tags

- latest: latest stable community edition
- 2.x: latest stable community edition 2.x.y
- 2.x.y: community edition 2.x.y


- enterprise: latest stable enterprise edition (you need a license to run this)
- enterprise-2.1: lastest stable enterprise edition 2.1.x
- enterprise-2.1.x: enterprise edition 2.1.x

