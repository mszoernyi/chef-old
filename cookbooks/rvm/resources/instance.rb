actions :create, :delete

attribute :version, :kind_of => String, :default => "1.25.18"

def initialize(name, run_context=nil)
  super
  @action = :create
end
