include_recipe "druid"

directory "/var/app/druid/config/middleManager" do
  owner "druid"
  group "druid"
  mode "0755"
end

template "/var/app/druid/config/middleManager/runtime.properties" do
  source "runtime.properties"
  owner "root"
  group "root"
  mode "0644"
  variables service: "middleManager"
end

template "/var/app/druid/bin/druid-middleManager" do
  source "runner.sh"
  owner "root"
  group "root"
  mode "0755"
  notifies :restart, "service[druid-middleManager]"
  variables service: "middleManager"
end

systemd_unit "druid-middleManager.service" do
  template "druid.service"
  notifies :restart, "service[druid-middleManager]"
end

service "druid-middleManager" do
  action [:enable, :start]
  subscribes :restart, "template[/var/app/druid/config/middleManager/runtime.properties]"
  subscribes :restart, "template[/var/app/druid/config/log4j.properties]"
  subscribes :restart, "template[/var/app/druid/bin/druid-middleManager]"
  subscribes :restart, "systemd_unit[druid-middleManager]"
end
