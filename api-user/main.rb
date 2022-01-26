require 'kong'
require_relative './kong2_compatible.rb'

Kong::Client.api_url = 'http://kong:8001'

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

# saveメソッドはputが送られてしまうので、オーバーライドしておくこと。
plugin.save
