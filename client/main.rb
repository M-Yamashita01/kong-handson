require 'kong'
require_relative './kong2_compatible.rb'

Kong::Client.api_url = 'http://kong:8001'

# Kongに登録されているサービスなどを全て削除
Kong::Upstream.all.each(&:delete)
Kong::Plugin.all.each(&:delete)
Kong::Route.all.each(&:delete)
Kong::Service.all.each(&:delete)
Kong::Consumer.all.each(&:delete)

# Consumer登録
consumer = Kong::Consumer.new({ username: 'test-user' })
consumer.create

# Service登録
service = Kong::Service.new(
  {
    name: 'example_service',
    protocol: 'https',
    host: 'mockbin.org',
    path: '/request'
  }
)
service.create

# Route登録
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

# Rate LimitingのPlugin登録
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
      minute: 20,
      hour: 500
    }
  }
)
plugin.create

# Upstream登録
upstream = Kong::Upstream.new({ name: 'upstream-service'})
upstream.create

# Upstreamに紐づくTarget登録
mockbin_target = Kong::Target.new( {
  upstream: {
    id: upstream.id
  },
  target: 'mockbin.org:443'
})
mockbin_target.create

httpbin_target = Kong::Target.new( {
  upstream: {
    id: upstream.id
  },
  target: 'httpbin.org:443'
})
httpbin_target.create

# Upstreamを既存のServiceに紐付けて更新
service2 = Kong::Service.new(
  {
    id: service.id,
    host: 'upstream-service'
  }
)

service2.update
