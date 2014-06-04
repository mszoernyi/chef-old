include_recipe "hadoop2"

HDFS_SERVICE = "namenode"
RESTARTS_ON = %w{
}
# TODO: restart on topology.data ?

service "hdfs@#{HDFS_SERVICE}" do
  action [:enable, :start]
  
  RESTARTS_ON.each do |conf_file|
    subscribes :restart, "template[/etc/hadoop2/#{conf_file}]"
  end
end
