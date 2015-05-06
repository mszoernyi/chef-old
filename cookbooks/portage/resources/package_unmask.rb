actions :create, :delete
default_action :create

attribute :package, kind_of: String, name_attribute: true
attribute :upgrade, kind_of: [TrueClass, FalseClass], default: true

def initialize(*args)
  super
  @run_context.include_recipe("portage")
end
