include_recipe "hadoop2"

pig_tar = "http://mirror.leaseweb.com/apache/pig/pig-#{node[:hadoop2][:pig][:version]}/pig-#{node[:hadoop2][:pig][:version]}.tar.gz"
pig_basedir = "/var/app/hadoop2/pig"
pig_dir = "#{pig_basedir}/pig-#{node[:hadoop2][:pig][:version]}"

directory pig_basedir do
  user "hadoop2"
  group "hadoop2"
  mode "0755"
end

tar_extract pig_tar do
  target_dir pig_basedir
  creates pig_dir
  user "hadoop2"
  group "hadoop2"
end

file "/var/app/hadoop2/current/bin/pig" do
  action :delete
end

template "/usr/bin/pig" do
  source "pig.sh"
  owner "root"
  group "root"
  mode "0755"
end

directory "/var/app/hadoop2/pig/contrib" do
  owner "hadoop2"
  group "hadoop2"
  mode "0755"
end

contrib_jars = Hash[node[:hadoop2][:pig][:default_jars].map do |contrib_uri|
  [contrib_uri, "/var/app/hadoop2/pig/contrib/#{contrib_uri.split('/')[-1]}"]
end]

contrib_jars.each do |contrib_uri, jar_name|
  remote_file jar_name do
    source contrib_uri
    user "hadoop2"
    group "hadoop2"
  end
end

Dir["/var/app/hadoop2/pig/contrib/*"].each do |file_name|
  unless contrib_jars.values.include? file_name
    file file_name do
      action :delete
    end
  end
end
