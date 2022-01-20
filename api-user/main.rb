require 'kong'

Kong::Client.api_url = 'http://kong-handson_kong-net:8001'

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
    name: 'Mockbin',
    protocol: 'https',
    host: 'mockbin.com',
    path: '/someremoteservice'
  }
)

service.create

route = Kong::Route.new(
  {
    name: 'Mockbin',
    service_id: service.id,
    uris: ['/someservice'],
    methods: ['GET'],
    strip_path: false,
    preserve_host: false
  }
)

route.create

