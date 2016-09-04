include_attribute "base"

default[:bash][:rcdir] = root? ? "/etc/bash" : "#{node[:homedir]}/.bash"
default[:bash][:profile] = root? ? "/etc/profile" : "#{node[:homedir]}/.profile"
default[:bash][:dircolors] = root? ? "/etc/DIR_COLORS" : "#{node[:homedir]}/.dir_colors"
default[:bash][:colordiffrc] = root? ? "/etc/colordiffrc" : "#{node[:homedir]}/.colordiffrc"
