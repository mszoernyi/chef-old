module CanHelpers

  def can_load_kernel_modules?
    return false if lxc?
    File.exist?("/proc/modules")
  end

  def can_run_ntpd?
    return false if lxc?
    return false if vbox?
    return true
  end

end

include CanHelpers

class Chef
  class Recipe
    include CanHelpers
  end

  class Node
    include CanHelpers
  end

  class Resource
    include CanHelpers
  end
end

