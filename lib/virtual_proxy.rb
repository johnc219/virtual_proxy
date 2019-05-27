require "virtual_proxy/version"
require "virtual_proxy/proxy"

# Quickly build virtual proxies.
module VirtualProxy
  def self.to(&block)
    Proxy.new(&block)
  end

  def build_lazy(*args, &block)
    Proxy.new { new(*args, &block) }
  end
end
