include AccountHelpers

use_inline_resources

action :create do
  nr = new_resource # rebind
  user = get_user(nr.user)
  path = user[:dir]
  shared_path = "#{path}/shared"

  template "#{path}/.gitconfig" do
    source "go/gitconfig"
    cookbook "deploy"
    owner nr.user
    mode "0644"
    action :delete unless nr.repository =~ /.*@.*:.*/
  end

  directory "#{path}/.go" do
    owner nr.user
    mode "0755"
  end

  directory "#{path}/shared/vendor" do
    owner nr.user
    mode "0755"
  end

  deploy_application user[:name] do
    repository nr.repository
    revision nr.revision
    user nr.user

    force nr.force

    purge_before_symlink nr.purge_before_symlink
    symlink_before_migrate({}) # see below
    symlinks nr.symlinks

    before_migrate do
      # symlink_before_migrate runs _after_ the before_migrate callback chain.
      # some applications rely on these symlinks to setup before_migrate tasks
      links = nr.symlink_before_migrate.merge({
        "cache" => "cache",
        "vendor" => ".vendor",
      })

      links.each do |src, dest|
        begin
          target = release_path + "/#{dest}"
          FileUtils.rm_rf(target) if ::File.exist?(target)
          FileUtils.ln_sf(shared_path + "/#{src}", target)
        rescue => e
          raise Chef::Exceptions::FileNotFound.new("Cannot symlink #{shared_path}/#{src} to #{release_path}/#{dest} before migrate: #{e.message}")
        end
      end

      execute "#{nr.user}-make" do
        command "make dep all"
        cwd release_path
        user nr.user
        environment({
          "HOME" => path,
          "GOPATH" => "#{path}/.go",
          "PATH" => "#{path}/.go/bin:#{ENV['PATH']}",
        })
      end

      ruby_block "#{nr.user}-after-make" do
        block do
          callback(:after_make, nr.after_make)
        end
      end
    end

    before_symlink nr.before_symlink
    before_restart nr.before_restart
  end
end
