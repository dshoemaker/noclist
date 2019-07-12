require 'digest'
require './api_client'

module NocList
  MAX_RETRIES = 3
  RESPONSE_DELIMITER = "\n"
  @@retry_count = 0

  def run
    client = ApiClient.new

    begin
      response = client.users
      json_results = response.body.split(RESPONSE_DELIMITER).to_json
      print json_results
      puts
      exit(0)
    rescue ApiClient::ApiError => err
      if retry_count >= MAX_RETRIES
        STDERR.puts(err.response.parsed_response)
        exit(err.response.code)
      else
        @@retry_count += 1
        retry
      end
    end
  end

  module_function :run
end

NocList.run
