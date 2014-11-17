#!/bin/bash

# host & port for our listen socket
PORT=<%= node[:druid][@service][:port] %>
HOST=<%= node[:fqdn] %>:${PORT}
JMXPORT=<%= node[:druid][@service][:port] + 10000 %>

# common JVM options
JVM_OPTS=""
JVM_OPTS+=" -server -d64"
JVM_OPTS+=" -Xmx<%= node[:druid][@service][:mx] %>m"
JVM_OPTS+=" -XX:MaxDirectMemorySize=<%= node[:druid][@service][:dm] %>m"
JVM_OPTS+=" -XX:+UseCompressedOops"
JVM_OPTS+=" -XX:+UseParNewGC"
JVM_OPTS+=" -XX:+UseConcMarkSweepGC"
JVM_OPTS+=" -XX:+CMSClassUnloadingEnabled"
JVM_OPTS+=" -XX:+CMSScavengeBeforeRemark"
JVM_OPTS+=" -XX:+DisableExplicitGC"
JVM_OPTS+=" -Duser.timezone=UTC"
JVM_OPTS+=" -Dfile.encoding=UTF-8"
JVM_OPTS+=" -Ddruid.service=<%= @service %>"
JVM_OPTS+=" -Ddruid.host=$HOST"
JVM_OPTS+=" -Ddruid.port=$PORT"
JVM_OPTS+=" -Dlog4j.configuration=file:///etc/druid/log4j.properties"
JVM_OPTS+=" -Djava.io.tmpdir=/var/app/druid/storage/tmp"
JVM_OPTS+=" -Dcom.sun.management.jmxremote.port=$JMXPORT"
JVM_OPTS+=" -Dcom.sun.management.jmxremote.authenticate=false"
JVM_OPTS+=" -Dcom.sun.management.jmxremote.ssl=false"

# service specific properties
<% monitors = node[:druid][:monitors] %>
<% case @service %>
<% when "realtime" %>
<% monitors += ["io.druid.segment.realtime.RealtimeMetricsMonitor"] %>
JVM_OPTS+=" -Ddruid.realtime.specFile=/etc/druid/realtime.spec"
JVM_OPTS+=" -Ddruid.server.tier=realtime"
<% when "historical" %>
JVM_OPTS+=" -Ddruid.server.tier=<%= node[:druid][:server][:tier] %>"
JVM_OPTS+=" -Ddruid.server.maxSize=<%= node[:druid][:server][:max_size] %>"
<% else %>
JVM_OPTS+=" -Ddruid.server.tier=<%= @service %>"
<% end %>
JVM_OPTS+=' -Ddruid.monitoring.monitors=<%= monitors.to_json %>'

# build the classpath - use node[:druid][:extensions] for more
CLASSPATH="/etc/druid"
CLASSPATH+=":$(/usr/bin/find /var/app/druid/current/services/target/*selfcontained.jar)"

# add hadoop if it exists
if [ -x <%= "/var/app/hadoop2/current/bin/hadoop" %> ]; then
  CLASSPATH+=":$(/var/app/hadoop2/current/bin/hadoop classpath)"
fi

exec /usr/bin/java $JVM_OPTS -cp $CLASSPATH io.druid.cli.Main server <%= @service %>
