package "dev-db/postgresql" do
  version ":#{node[:postgresql][:slot]}"
end

chef_gem 'pg' do
  action :install
  compile_time false
end
