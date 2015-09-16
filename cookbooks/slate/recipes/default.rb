if !root?
  overridable_template "#{node[:homedir]}/.slate" do
    source "slate.local"
    cookbook "users"
    instance node[:current_user]
  end
end
