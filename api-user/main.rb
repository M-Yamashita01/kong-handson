require 'kong'
require_relative './kong2_compatible.rb'

Kong::Client.api_url = 'http://kong:8001'

Kong::Upstream.all.each(&:delete)
Kong::Plugin.all.each(&:delete)
Kong::Route.all.each(&:delete)
Kong::Service.all.each(&:delete)
Kong::Consumer.all.each(&:delete)

service = Kong::Service.new(
  {
    name: 'example_service',
    protocol: 'https',
    host: 'mockbin.org',
    path: '/request',
    port: 443
  }
)

service.create

route = Kong::Route.new(
  {
    name: 'mocking',
    service: {
      id: service.id
    },
    paths: ['/mock'],
    methods: ['GET']
  }
)

route.create

consumer = Kong::Consumer.new({ username: 'test-user' })
consumer.create

plugin = Kong::Plugin.new(
  {
    service: {
      id: service.id
    },
    consumer: {
      id: consumer.id
    },
    name: "rate-limiting",
    config: {
      second: 5
    }
  }
)

plugin.create

upstream = Kong::Upstream.new({ name: 'upstream-service'})
upstream.create

target1 = Kong::Target.new( {
  upstream: {
    id: upstream.id
  },
  target: 'mockbin.org:443'
})
target1.create


Kong::Target.new( {
  upstream: {
    id: upstream.id
  },
  target: 'httpbin.org:443'
}).create

service2 = Kong::Service.new(
  {
    id: service.id,
    host: 'upstream-service'
  }
)

service2.update
