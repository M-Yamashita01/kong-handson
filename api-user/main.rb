require 'kong'

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

cursor = {
  'config': {
    minute: 5
  }
}

if cursor['config']
  memo = flatten(cursor.delete('config'), 'config')
end

plugin = Kong::Plugin.new(
  {
    service: {
      id: service.id
    },
    consumer: {
      id: consumer.id
    },
    name: 'rate-limiting',
    config: {
      minute: 5
    }
  }
)

plugin.create


def flatten(cursor, parent_key = nil, memo = {})
  memo.tap do
    case cursor
    when Hash
      cursor.keys.each do |key|
        flatten(cursor[key], [parent_key, key].compact.join('.'), memo)
      end
    else
      memo["#{parent_key}"] = cursor
    end
  end
end