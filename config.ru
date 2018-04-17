require "rack"
require "httparty"

class App

  def initialize
    @cache = {}
  end

  def call(env)
    return cached_response(env) if cached_response?(env)
    fetch_response_from_backend(env)
  end

  private

  def fetch_response_from_backend(env)
    response = HTTParty.get(backend_url)
    sanitized_headers = Hash[response.headers.to_h.map{ |key, value| [key, value.first] }]
    sanitized_headers.delete("content-length") # TODO work out why I needed to do this
    response = [response.code, sanitized_headers, [response.body]]
    add_to_cache(env, response)
    response
  end

  def backend_url
    ENV.fetch("BACKEND_URL")
  end


  def cached_response?(env)
    cache_key = build_cache_key_from_env(env)
    @cache.include?(cache_key)
  end

  def cached_response(env)
    cache_key = build_cache_key_from_env(env)
    @cache[cache_key]
  end

  def add_to_cache(env, response)
    cache_key = build_cache_key_from_env(env)
    @cache[cache_key] = response
  end

  def build_cache_key_from_env(env)
    "#{env["REQUEST_METHOD"]}-#{env["REQUEST_URI"]}-#{env["REQUEST_PATH"]}"
  end

end

run App.new
