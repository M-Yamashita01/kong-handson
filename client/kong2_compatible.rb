# kong-client-rubyのパッチ
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
      if self.attributes['upstream'] && self.attributes['upstream'][:id]
        self.api_end_point = "/upstreams/#{self.attributes['upstream'][:id]}#{self.class::API_END_POINT}" 
      end
    end
  end
end
