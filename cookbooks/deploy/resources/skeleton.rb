actions :create

attribute :homedir, :kind_of => String
attribute :groups, :kind_of => Array, :default => []
attribute :shared, :kind_of => Array, :default => []
attribute :key_source, :kind_of => String
attribute :authorized_keys_for, :kind_of => [Symbol, Array, FalseClass]

def initialize(name, run_context=nil)
  super(name, run_context)
  @action = :create
end
