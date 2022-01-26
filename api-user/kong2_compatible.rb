module Kong
  class Plugin
    def save
      headers = { 'Content-Type' => 'application/json' }
      response = client.post(@api_end_point, attributes, nil, headers)
      init_attributes(response)
      self
    end
  end
end
