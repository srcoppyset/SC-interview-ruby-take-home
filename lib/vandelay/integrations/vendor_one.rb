module Vandelay
  module Interations
    class VendorOne
      BASE_URL = Vandelay.config.dig('integrations', 'vendors', 'one', 'api_base_url')

      def self.fetch_token
        response = Net::HTTP.get(URI("#{BASE_URL}/auth/1"))
        JSON.parse(response)['token']
      end

      def self.fetch_patient_record(vendor_id)
        token = fetch_token
        uri = URI("#{BASE_URL}/patients/#{vendor_id}")
        req = Net::HTTP::Get.new(uri)
        req['Authorization'] = "Bearer #{token}"

        res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(req) }
        JSON.parse(res.body)
      end
    end
  end
end
