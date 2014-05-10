chef_server_url "https://localhost"

# do not change anything below here
chef_repo_path File.expand_path(File.join(File.dirname(__FILE__), ".."))

if Process.euid == 0
  chef_root = "/var/lib/chef"
  node_name %x(hostname -f).chomp
else
  chef_root = File.expand_path("~/.chef")
  node_name %x(whoami).chomp
end

cookbook_path [
  "#{chef_repo_path}/cookbooks",
  "#{chef_repo_path}/site-cookbooks",
]

script_path "#{chef_repo_path}/scripts"

client_key "#{chef_repo_path}/.chef/client.pem"

validation_client_name node_name
validation_key client_key

syntax_check_cache_path "#{chef_repo_path}/.chef/checksums"

file_cache_path "#{chef_root}/cache/files"
file_backup_path "#{chef_root}/backup"

ssl_verify_mode :verify_none
