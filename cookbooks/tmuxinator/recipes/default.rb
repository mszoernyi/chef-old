gem_package "tmuxinator"

if !root?
  overridable_template "#{node[:homedir]}/.tmuxinator/chef.yml" do
    source "tmuxinator/chef.yml"
    cookbook "users"
    instance node[:current_user]
  end
  overridable_template "#{node[:homedir]}/.tmuxinator/company-site.yml" do
    source "tmuxinator/company-site.yml"
    cookbook "users"
    instance node[:current_user]
  end
  overridable_template "#{node[:homedir]}/.tmuxinator/dashboard.yml" do
    source "tmuxinator/dashboard.yml"
    cookbook "users"
    instance node[:current_user]
  end
  overridable_template "#{node[:homedir]}/.tmuxinator/remerge.yml" do
    source "tmuxinator/remerge.yml"
    cookbook "users"
    instance node[:current_user]
  end
end
