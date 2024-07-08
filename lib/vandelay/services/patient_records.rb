require 'vandelay/integrations/vendor_one'
require 'vandelay/integrations/vendor_two'

module Vandelay
  module Services
    class PatientRecords
      CACHE_EXPIRY = 600 # 10 minutes
      def retrieve_record_for_patient(patient)
        cache_key = "patient_record_#{patient.id}"
        cached_record = Vandelay.redis.get(cache_key)
        return JSON.parse(cached_record) if cached_record

        record = case patient.records_vendor
        when 'vendor_one'
          VendorOne.fetch_patient_record(patient.vendor_id)
        when 'vendor_two'
          VendorTwo.fetch_patient_record(patient.vendor_id)
        end

        filtered_record = {
          patient_id: patient.id,
          province: record['province'],
          allergies: record['allergies'],
          num_medical_visits: record['num_medical_visits']
        }

        Vandelay.redis.set(cache_key, filtered_record.to_json)
        Vandelay.redis.expire(cache_key, CACHE_EXPIRY)
        filtered_record
      end
    end
  end
end
