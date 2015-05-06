if gentoo?
  package "sys-process/htop"
elsif debian_based?
  package "htop"
elsif mac_os_x?
  homebrew_package "htop-osx"
end

directory "#{node[:homedir]}/.config/htop" do
  recursive true
  mode "0755"
end

cookbook_file "#{node[:homedir]}/.config/htop/htoprc" do
  source "htoprc"
  mode "0644"
end
