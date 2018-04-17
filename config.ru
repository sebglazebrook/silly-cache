require "rack"
require "httparty"

class App

  def call(env)
    fetch_response_from_backend(env)
  end

  private

  def fetch_response_from_backend(env)
    response = HTTParty.get("http://google.com")
    sanitized_headers = Hash[response.headers.to_h.map{ |key, value| [key, value.first] }]
    sanitized_headers.delete("content-length") # TODO work out why I needed to do this
    [response.code, sanitized_headers, [response.body]]
  end

end

run App.new
