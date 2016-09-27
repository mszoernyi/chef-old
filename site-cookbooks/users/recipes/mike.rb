if mac_os_x?
  homebrew_package "keychain"
  homebrew_package "gpg-agent"
end

remote_file "#{node[:homedir]}/bin/gimme" do
  source "https://raw.githubusercontent.com/travis-ci/gimme/master/gimme"
  mode 0755
end
