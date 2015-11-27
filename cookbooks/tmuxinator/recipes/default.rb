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
  overridable_template "#{node[:homedir]}/.tmuxinator/ember-remerge.yml" do
    source "tmuxinator/ember-remerge.yml"
    cookbook "users"
    instance node[:current_user]
  end
  overridable_template "#{node[:homedir]}/.tmuxinator/remerge-admin.yml" do
    source "tmuxinator/remerge-admin.yml"
    cookbook "users"
    instance node[:current_user]
  end
  overridable_template "#{node[:homedir]}/.tmuxinator/remerge-my.yml" do
    source "tmuxinator/remerge-my.yml"
    cookbook "users"
    instance node[:current_user]
  end
  overridable_template "#{node[:homedir]}/.tmuxinator/remerge-ui.yml" do
    source "tmuxinator/remerge-ui.yml"
    cookbook "users"
    instance node[:current_user]
  end
  overridable_template "#{node[:homedir]}/.tmuxinator/remerge-api.yml" do
    source "tmuxinator/remerge-api.yml"
    cookbook "users"
    instance node[:current_user]
  end
  overridable_template "#{node[:homedir]}/.tmuxinator/remerge-backend.yml" do
    source "tmuxinator/remerge-backend.yml"
    cookbook "users"
    instance node[:current_user]
  end
end
