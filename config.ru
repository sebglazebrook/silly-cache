require "rack"
require "httparty"
require 'digest'

class App

  def initialize
    @cache = {}
  end

  def call(env)
    return cached_response(env) if cached_response?(env)
    puts "[DEBUG] Not using cache"
    $stdout.flush
    fetch_response_from_backend(env)
  end

  private

  def fetch_response_from_backend(env)
    response = send_request(env)
    sanitized_headers = Hash[response.headers.to_h.map{ |key, value| [key, value.first] }]
    sanitized_headers.delete("content-length") # TODO work out why I needed to do this
    ret = [response.code, sanitized_headers, [response.body]]
    puts "[DEBUG] #{response.code}"
    puts "[DEBUG] #{response.body}"
    $stdout.flush
    add_to_cache(env, ret)
    ret
  end

  def send_request(env)
    headers = env.select { |key, value| key.start_with?("HTTP_") }.inject({}) { |memo, (key, value)|  memo[key.gsub("HTTP_", "")] = value; memo }
    body = Rack::Request.new(env).body.read
    Rack::Request.new(env).body.rewind
    url = "#{backend_url}#{env["PATH_INFO"]}" # TODO will need to handle query params in the future
    response = HTTParty.send(env["REQUEST_METHOD"].downcase.to_sym, url, { headers: headers.merge("Content-Type" => "application/json"), body: body })
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
    body = Rack::Request.new(env).body.read
    Rack::Request.new(env).body.rewind
    key = Digest::SHA1.hexdigest("#{env["REQUEST_METHOD"]}-#{env["REQUEST_URI"]}-#{env["REQUEST_PATH"]}-#{body}")
    key
  end

end

run App.new
