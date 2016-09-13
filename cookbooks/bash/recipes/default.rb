if gentoo?
  package "app-shells/bash"
  package "app-shells/bash-completion"

elsif debian_based?
  package "bash"
  package "bash-completion"

elsif mac_os_x?
  homebrew_package "bash"
  homebrew_package "bash-completion"
  execute "sudo dscl . -create /Users/#{node[:current_user]} UserShell '/usr/local/bin/bash'"
end

file node[:bash][:profile] do
  action :delete
  manage_symlink_source false
  only_if { File.symlink?(node[:bash][:profile]) }
end

cookbook_file node[:bash][:profile] do
  source "profile"
  mode "0644"
end

remote_directory node[:bash][:rcdir] do
  source "dot-bash"
  files_mode "0644"
  mode "0755"
end

%w(
  .bash_login
  .bash_logout
  .bash_profile
  .bashrc
).each do |f|
  file "#{node[:homedir]}/#{f}" do
    action :delete
    manage_symlink_source false
  end
end

if root?
  # most distributions use /etc/bash.bashrc and /etc/bash.bash_logout but we
  # follow the gentoo way of putting these in /etc/bash loaded via /etc/profile
  file "/etc/bash.bashrc" do
    action :delete
    manage_symlink_source false
  end

  file "/etc/bash.bash_logout" do
    action :delete
    manage_symlink_source false
  end
else
  overridable_template "#{node[:homedir]}/.bashrc.local" do
    source "bashrc.local"
    cookbook "users"
    instance node[:current_user]
  end
end

# various color fixes for solarized
cookbook_file node[:bash][:dircolors] do
  source "dircolors.ansi-universal"
  mode "0644"
end

cookbook_file node[:bash][:colordiffrc] do
  source "colordiffrc"
  mode "0644"
end

remote_directory node[:script_path] do
  source "scripts"
  files_mode "0755"
  mode "0755"
end

execute "env-update" do
  action :nothing
  only_if { gentoo? }
end
