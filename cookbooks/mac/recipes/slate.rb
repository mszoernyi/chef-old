if mac_os_x?
  mac_package "Install Slate" do
    source "https://github.com/mattr-/slate/releases/download/v1.2.0/Slate.zip"
    type "zip_app"
    not_if { File.exist?("/Applications/Slate.app") }
  end

  overridable_template "#{node[:homedir]}/.slate" do
    source "slate.local"
    cookbook "users"
    instance node[:current_user]
  end
end
