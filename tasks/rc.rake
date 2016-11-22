# remote commands for maintenance

namespace :rc do

  desc "Update gentoo packages"
  task :updateworld do
    search("platform:gentoo") do |node|
      run_task('node:updateworld', node.name)
    end
  end

  desc "Run chef-client"
  task :deploy do
    search("*:*") do |node|
      system("ssh -t #{node.name} '/usr/bin/sudo -Hi chef-client'")
      puts "sleeping for 1 minute ..."
      sleep(60)
    end
  end

  desc "Open interactive shell"
  task :shell do
    search("*:*") do |node|
      if ENV.key?('NOSUDO')
        system("ssh -t #{node.name}'")
      else
        system("ssh -t #{node.name} '/usr/bin/sudo -i'")
      end
    end
  end

  desc "Reboot machines and wait until they are up"
  task :reboot do
    search("default_query:does_not_exist") do |node|
      system("ssh -t #{node.name} '/usr/bin/sudo -i reboot'")
      wait_for_ssh(node[:fqdn])
      puts "Sleeping 5 minutes to slow down reboot loop"
      sleep 5*60
    end
  end

  desc "Run custom script"
  task :script, :name, :params do |t, args|
    script = File.join(ROOT, 'scripts', args.name)
    raise "script '#{args.name}' not found" if not File.exist?(script)
    search("*:*") do |node|
      if ENV.key?('NOSUDO')
        system("cat '#{script}' | ssh #{node.name} '/bin/bash -s'")
      else
        system("cat '#{script}' | ssh #{node.name} '/usr/bin/sudo -i /bin/bash -s #{args.params}'")
      end
    end
  end
end
