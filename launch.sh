#!/bin/bash

NEO4J_HOME=/var/lib/neo4j

LOCAL_IPADDR=$(ip a s | sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}')

NEO4J_HOST=${NEO4J_HOST:-$LOCAL_IPADDR}
NEO4J_SHELL_HOST=${NEO4J_SHELL_HOST:-$LOCAL_IPADDR}
NEO4J_URI_PREFIX=${NEO4J_URI_PREFIX:-}
NEO4J_INDEX_NODE=${NEO4J_INDEX_NODE:-true}
NEO4J_INDEX_NODE_KEYS=${NEO4J_INDEX_NODE_KEYS:-name}
NEO4J_INDEX_REL=${NEO4J_INDEX_REL:-true}
NEO4J_INDEX_REL_KEYS=${NEO4J_INDEX_REL_KEYS:-name}

# update ip
sed -i "s|#org.neo4j.server.webserver.address=0.0.0.0|org.neo4j.server.webserver.address=$NEO4J_HOST|g" $NEO4J_HOME/conf/neo4j-server.properties
sed -i "s|#remote_shell_enabled=true|remote_shell_enabled=true|g" $NEO4J_HOME/conf/neo4j.properties
sed -i "s|#remote_shell_host=127.0.0.1|remote_shell_host=$NEO4J_SHELL_HOST|g" $NEO4J_HOME/conf/neo4j.properties

# url prefix (for http endpoints)
sed -i "s|uri=/db/|uri=$NEO4J_URI_PREFIX/db/|g" $NEO4J_HOME/conf/neo4j-server.properties

# hack browser config for url adjustment
# - note that browser only mounts at /, thus requiring a reverse proxy
cd /var/lib/neo4j/system/lib;  \
  jar xf neo4j-browser-*.jar; \
  sed -i "s|baseURL=\"\"|baseURL=\"..$NEO4J_URI_PREFIX\"|" browser/scripts/*.scripts.js; \
  jar uf neo4j-browser-*.jar browser/scripts/*.scripts.js; \
  chown neo4j:adm neo4j-browser-*.jar browser/scripts/*.scripts.js; \
  rm -rf browser org

# indexing settings
sed -i "s|#node_auto_indexing=true|node_auto_indexing=$NEO4J_INDEX_NODE|g" /var/lib/neo4j/conf/neo4j.properties
sed -i "s|#node_keys_indexable=name,age|node_keys_indexable=$NEO4J_INDEX_NODE_KEYS|g" /var/lib/neo4j/conf/neo4j.properties
sed -i "s|#relationship_auto_indexing=true|relationship_auto_indexing=$NEO4J_INDEX_REL|g" /var/lib/neo4j/conf/neo4j.properties
sed -i "s|#relationship_keys_indexable=name,age|relationship_keys_indexable=$NEO4J_INDEX_REL_KEYS|g" /var/lib/neo4j/conf/neo4j.properties

#other
#sed -i "s|#allow_store_upgrade=true|allow_store_upgrade=true|g" $NEO4J_HOME/conf/neo4j.properties

# update file limits
ulimit -n 65536

exec $NEO4J_HOME/bin/neo4j console
