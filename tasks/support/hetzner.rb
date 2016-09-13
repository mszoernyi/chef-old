def hetzner
  @hetzner ||= Hetzner::API.new($conf.hetzner.username, $conf.hetzner.password)
end

def is_hetzner?(ip)
  return false unless $conf.hetzner && $conf.hetzner.username
  return !hetzner.server?(ip)['error'].present?
end

def hetzner_server_name_rdns(ip, fqdn)
  return unless is_hetzner?(ip)
  puts "Setting reverse DNS for #{ip} to #{fqdn}"
  hetzner.server!(ip, server_name: fqdn)
  hetzner.rdns!(ip, fqdn)
end

def hetzner_enable_rescue_wait(ip)
  return unless is_hetzner?(ip)
  hetzner.disable_rescue!(ip)
  res = hetzner.enable_rescue!(ip, 'linux', '64')
  password = res.parsed_response["rescue"]["password"]
  puts "rescue password is #{password.inspect}"
  hetzner.reset!(ip, :hw)
  wait_for_ssh(ip, false)
  password
end
