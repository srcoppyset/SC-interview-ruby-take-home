require 'vandelay/services/patients'
require 'vandelay/services/patient_records'

module Vandelay
  module REST
    module PatientsPatient
      def self.registered(app)
        app.get '/patients/:id' do
          patient = Patient.find_by(id: params[:id])
          patient ? json(patient) : json({ status: 404, error: 'Patient not found' })
        end
      end

      def self.patients_record(app)
        app.get '/patients/:patient_id/record' do
          patient = Patient.find_by(id: params[:patient_id])
          if patient
            records_service = PatientRecords.new
            record = records_service.retrieve_record_for_patient(patient)
            json(record)
          else
            json({ status: 404, error: 'Patient not found' })
          end
        end
      end
    end
  end
end
