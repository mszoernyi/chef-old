include_recipe "hadoop2"

execute "hadoop-namenode-format" do
  command "/var/app/hadoop2/current/bin/hdfs namenode -format #{node[:hadoop2][:hdfs][:cluster]}"
  creates "/var/app/hadoop2/storage/namenode/current/VERSION"
  user "hadoop2"
  group "hadoop2"
end

service "hdfs@namenode" do
  action [:enable, :start]
  subscribes :restart, "template[/etc/hadoop2/core-site.xml]"
  subscribes :restart, "template[/etc/hadoop2/hdfs-site.xml]"
end

nrpe_command "check_hdfs_namenode_stat" do
  command "/usr/lib/nagios/plugins/check_jstat -j org.apache.hadoop.hdfs.server.namenode.NameNode"
end

nagios_service "HDFS-NAMENODE" do
  check_command "check_nrpe!check_hdfs_namenode_stat"
  servicegroups "hdfs,hdfs-namenode"
end

nagios_cluster_service "HDFS-NAMENODES" do
  check_command "check_aggregate!HDFS-DATANODE-STAT!0.1!0.3"
  servicegroups "hdfs,hdfs-namenode"
end

nagios_service "HDFS-NAMENODE-RPC" do
  check_command "check_tcp!8020!-w 1 -c 1"
  servicegroups "hdfs,hdfs-namenode"
end

{
  :nodes => [:NameNode, nil, nil],
  :latency => [:NameNodeLatency, 0.25, 0.5],
  :checkpoint => [:NameNodeCheckpointTime, 60*60, 2*60*60],
  :journal => [:NameNodeJournalTransactions, 1000000, 2000000],
  :state => [:Dfs, nil, nil],
  :capacity => [:DfsCapacity, 75, 90],
  :blocks => [:DfsBlocks, 50, 100],
}.each do |name, params|
  name = name.to_s

  nrpe_command "check_hdfs_namenode_#{name}" do
    command "/usr/lib/nagios/plugins/check_hdfs -m #{params[0]} -u http://#{node[:ipaddress]}:50070/jmx -w #{params[1]} -c #{params[2]}"
  end

  nagios_service "HDFS-NAMENODE-#{name.gsub(/_/, '-').upcase}" do
    check_command "check_nrpe!check_hdfs_namenode_#{name}"
    servicegroups "hdfs,hdfs-namenode"
  end
end

nagios_service "HDFS-NAMENODE-WEBUI" do
  check_command "check_http!-p 50070 -u /dfshealth.jsp -s 'reported blocks'"
  servicegroups "hdfs,hdfs-namenode"
end

namenodes = hadoop2_namenodes.map { |n| n[:fqdn] }

nrpe_command "check_hdfs_namenode_ha" do
  command "/usr/lib/nagios/plugins/check_hdfs_namenode_ha #{namenodes.join(',')} 50070"
end

nagios_service "HDFS-NAMENODE-HA" do
  check_command "check_nrpe!check_hdfs_namenode_ha"
  servicegroups "hdfs,hdfs-namenode"
end
