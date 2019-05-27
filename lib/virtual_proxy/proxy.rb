module VirtualProxy
  # Forward messages to a lazily-evaluated subject
  class Proxy < Delegator
    def initialize(&block)
      @block = block
    end

    def __getobj__
      @__getobj__ ||= @block.call
    end

    def __setobj__(&block)
      @block = block
      @__getobj__ = nil
    end
  end
end
