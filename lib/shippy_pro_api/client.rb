require 'faraday'

module ShippyProAPI
  class Client
    BASE_URL = 'https://www.shippypro.com/api'

    attr_reader :api_key, :adapter

    def initialize(api_key:, adapter: Faraday.default_adapter)
      @api_key = api_key
      @adapter = adapter
    end

    def connection
      @connection ||= Faraday.new do |conn|
        conn.url_prefix = BASE_URL
        conn.headers['Authorization'] = "Basic #{encoded_credentials}"
        conn.request :json
        conn.response :json, content_type: "application/json"
        conn.adapter adapter
      end
    end

    def shipment
      ShipmentResource.new(self)
    end
    
    private

    def encoded_credentials
      Base64.strict_encode64("#{api_key}:")
    end
  end
end