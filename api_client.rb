require 'httparty'

class ApiClient
  class ApiError
    attr_reader :response
    def initialize(response)
      @response = response
    end
  end
  include HTTParty
  base_uri 'http://0.0.0.0:8888'
  attr_reader :auth_token

  def auth
    response = self.class.get('/auth')
    raise ApiError.new(response) if response.code != 200
    @auth_token = response.headers['badsec-authentication-token']
    response
  end

  def users
    self.auth if auth_token.nil?
    response = self.class.get("/users", headers: {'X-Request-Checksum' => build_checksum('/users')})
    raise ApiError.new(response) if response.code != 200
    response
  end

  private

    def build_checksum(route)
      Digest::SHA2.new(256).hexdigest("#{auth_token}#{route}")
    end
end
