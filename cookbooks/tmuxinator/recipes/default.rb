gem_package "tmuxinator"

if !root?
  overridable_template "#{node[:homedir]}/.tmuxinator/dashboard.yml" do
    source "tmuxinator/dashboard.yml"
    cookbook "users"
    instance node[:current_user]
  end
end
