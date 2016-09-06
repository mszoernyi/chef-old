gem_package "tmuxinator" do
  action :upgrade
end

template "#{node[:script_path]}/tmuxinator-autocomplete.sh" do
  source "autocomplete.sh"
  mode "0755"
end

if !root?
  overridable_template "#{node[:homedir]}/.tmuxinator/remerge.yml" do
    source "tmuxinator/remerge.yml"
    cookbook "users"
    instance node[:current_user]
  end
  overridable_template "#{node[:homedir]}/.tmuxinator/own.yml" do
    source "tmuxinator/own.yml"
    cookbook "users"
    instance node[:current_user]
  end
end
