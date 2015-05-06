begin
  require 'open4'
  include Open4
rescue LoadError
end

def create_rvm_shell_chef_wrapper
  require 'chef/mixin/command'

  klass = Class.new(::RVM::Shell::AbstractWrapper) do
    include Chef::Mixin::Command

    attr_accessor :current

    def initialize(user = nil, sh = 'bash -l', &setup_block)
      @user = user
      super(sh, &setup_block)
    end

    # Runs a given command in the current shell.
    # Defaults the command to true if empty.
    def run_command(command)
      command = "true" if command.to_s.strip.empty?
      with_shell_instance do
        Chef::Log.debug("RVM::Shell::ChefWrapper executing: " +
          "[#{wrapped_command(command)}]")
        stdin.puts wrapped_command(command)
        stdin.close
        out, err = stdout.read, stderr.read
        out, status, _ = raw_stdout_to_parts(out)
        Chef::Log.debug('RVM::Shell::ChefWrapper status: ' + status.inspect)
        Chef::Log.debug('RVM::Shell::ChefWrapper stdout: ' + out)
        Chef::Log.debug('RVM::Shell::ChefWrapper stderr: ' + err)
        return status, out, err
      end
    end

    # Runs a command, ensuring no output is collected.
    def run_command_silently(command)
      with_shell_instance do
        Chef::Log.debug("RVM::Shell::ChefWrapper silently executing: " +
          "[#{wrapped_command(command)}]")
        stdin.puts silent_command(command)
      end
    end

    protected

    # yields stdio, stderr and stdin for a shell instance.
    # If there isn't a current shell instance, it will create a new one.
    # In said scenario, it will also cleanup once it is done.
    def with_shell_instance(&blk)
      no_current = @current.nil?
      if no_current
        Chef::Log.debug("RVM::Shell::ChefWrapper subprocess executing with " +
          "environment of: [#{shell_params.inspect}].")
        @current = popen4(self.shell_executable, shell_params)
        invoke_setup!
      end
      yield
    ensure
      @current = nil if no_current
    end

    # Direct access to each of the named descriptors
    def stdin;  @current[1]; end
    def stdout; @current[2]; end
    def stderr; @current[3]; end

    def shell_params
      {
        :user => @user,
        :environment => {
          'USER' => @user,
          'HOME' => Etc.getpwnam(@user).dir
        }
      }
    end
  end

  ::RVM::Shell.const_set('ChefWrapper', klass)
  ::RVM::Shell.default_wrapper = ::RVM::Shell::ChefWrapper
end
