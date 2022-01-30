require 'pry'

module Kong
  class Plugin
    def create
      super
    end
  end

  class Target
    def initialize(attributes = {})
      super(attributes)
    end

    def use_upstream_end_point
      self.api_end_point = "/upstreams/#{self.attributes['upstream'][:id]}#{self.class::API_END_POINT}" if self.attributes['upstream'] && self.attributes['upstream'][:id]
    end
  end 
end
