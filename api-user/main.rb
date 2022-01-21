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
    name: 'MockbinService',
    protocol: 'https',
    host: 'mockbin.org',
    path: '/request'
  }
)

service.create

route = Kong::Route.new(
  {
    name: 'MockbinRoute',
    service: {
      id: service.id
    },
    paths: ['/someservice'],
    methods: ['GET'],
    strip_path: false,
    preserve_host: false
  }
)

route.create
