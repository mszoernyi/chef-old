#!/bin/bash

cd /var/app/hadoop2/pig/pig-<%= node[:hadoop2][:pig][:version] %>

for JAR in /var/app/hadoop2/pig/contrib/*.jar; do
  PIG_DEFAULT_JARS+=${PIG_DEFAULT_JARS:+":"}$JAR
done

export PIG_OPTS="${PIG_OPTS} -Dpig.additional.jars=$PIG_DEFAULT_JARS"

exec ./bin/pig "$@"
