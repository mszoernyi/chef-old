#!/bin/bash

# host & port for our listen socket
PORT=<%= @druid_port %>
HOST=<%= node[:fqdn] %>:${PORT}
JMXPORT=<%= @druid_port + 10000 %>

echo "spawning druid <%= @druid_service %> on $PORT, JMX on $JMXPORT"

# JVM options
JVM_OPTS=""
JVM_OPTS+=" -server -d64"
JVM_OPTS+=" -Xmx<%= @druid_mx %>"
JVM_OPTS+=" -XX:MaxDirectMemorySize=<%= @druid_dm %>"
JVM_OPTS+=" -XX:+UseConcMarkSweepGC"
JVM_OPTS+=" -Duser.timezone=UTC"
JVM_OPTS+=" -Dfile.encoding=UTF-8"
JVM_OPTS+=" -Ddruid.host=$HOST"
JVM_OPTS+=" -Ddruid.port=$PORT"
JVM_OPTS+=" -Dlog4j.configuration=file:///etc/druid/log4j.properties"
JVM_OPTS+=" -Djava.io.tmpdir=/var/app/druid/storage/tmp"
JVM_OPTS+=" -Dcom.sun.management.jmxremote.port=$JMXPORT"
JVM_OPTS+=" -Dcom.sun.management.jmxremote.authenticate=false"
JVM_OPTS+=" -Dcom.sun.management.jmxremote.ssl=false"
<% if @druid_spec_file %>
JVM_OPTS+=" -Ddruid.realtime.specFile=<%= @druid_spec_file %>"
<% end %>

# build the classpath - use node[:druid][:extensions] for more
CLASSPATH="/etc/druid"
CLASSPATH+=":$(/usr/bin/find /var/app/druid/current/services/target/*selfcontained.jar)"

# add hadoop if it exists
if [ -x <%= "#{node[:druid][:hadoop][:path]}/hadoop" %> ]; then
  CLASSPATH+=":$(<%= "#{node[:druid][:hadoop][:path]}/hadoop" %> classpath)"
fi

exec /usr/bin/java $JVM_OPTS -cp $CLASSPATH io.druid.cli.Main server <%= @druid_service %>
