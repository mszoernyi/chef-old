default[:skip][:postfix_satelite] = false

default[:postfix][:use_flags] = []

default[:postfix][:message_size_limit] = 10
default[:postfix][:mynetworks] = []
default[:postfix][:rbl_servers] = %w(zen.spamhaus.org bl.spamcop.net)

default[:postfix][:postgrey][:opts] = ""
default[:postfix][:postgrey][:delay] = "300"
