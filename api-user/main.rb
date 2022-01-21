require 'kong'

Kong::Client.api_url = 'http://kong:8001'

routes = Kong::Route.all()
routes.each do |route|
  route.delete
end

services = Kong::Service.all()
services.each do |service|
  service.delete
end

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
