default[:hadoop2][:version] = "2.7.2"

default[:hadoop2][:hdfs][:cluster] = node.cluster_name
default[:hadoop2][:hdfs][:zookeeper] = node.cluster_name

default[:hadoop2][:yarn][:cluster] = node.cluster_name
default[:hadoop2][:yarn][:zookeeper] = node.cluster_name

default[:hadoop2][:rack_id] = nil # use node[:rack_id]

default[:hadoop2][:tmp_dir] = "/var/tmp/hadoop2"
default[:hadoop2][:java_tmp] = "/var/tmp/java"

default[:hadoop2][:zookeeper][:cluster] = node.cluster_name

default[:hadoop2][:pig][:version] = "0.16.0"
default[:hadoop2][:pig][:default_jars] = %w{
  http://search.maven.org/remotecontent?filepath=com/googlecode/json-simple/json-simple/1.1.1/json-simple-1.1.1.jar
  http://search.maven.org/remotecontent?filepath=com/twitter/elephantbird/elephant-bird-pig/4.5/elephant-bird-pig-4.5.jar
  http://search.maven.org/remotecontent?filepath=com/twitter/elephantbird/elephant-bird-hadoop-compat/4.5/elephant-bird-hadoop-compat-4.5.jar
  http://search.maven.org/remotecontent?filepath=org/apache/pig/piggybank/0.13.0/piggybank-0.13.0.jar
  http://search.maven.org/remotecontent?filepath=mysql/mysql-connector-java/5.1.29/mysql-connector-java-5.1.29.jar
  http://search.maven.org/remotecontent?filepath=com/linkedin/datafu/datafu/1.2.0/datafu-1.2.0.jar
  https://d2ljt3w7wnnuw2.cloudfront.net/commons-codec-1.9.jar
}

default[:hadoop2][:fs][:s3][:access_key] = nil
default[:hadoop2][:fs][:s3][:secret_key] = nil

default[:hadoop2][:du][:reserved] = 0
default[:hadoop2][:decommissioning] = []

# HDFS cleanup script
default[:hadoop2][:hdfs][:clean] = {}
