module AccountBlock
  class DoctorPatientsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token

    def create_doctor_patients
      doctor_patients = jsonapi_deserialize(params)
      @new_patient = AccountBlock::DoctorPatient.new(
       doctor_patients.merge({ doctor_id: current_doctor.id }))
      if @new_patient.save
        array = []
        if params[:data][:attributes][:diseases].present?
          params[:data][:attributes][:diseases].each do |ab|
            array << ab
          end
          @new_patient.update({:diseases => array})
        end
        render json: AccountBlock::DoctorPatientSerializer.new(@new_patient, meta: {message: 'Patient Created Successfully'}).serializable_hash, status: :created
      else
        render json: { errors: format_activerecord_errors(@new_patient.errors) },
               status: :unprocessable_entity
      end
    end

    def show_doctor_patients 
      @new_patient = AccountBlock::DoctorPatient.find(params[:id])
      if @new_patient
        render json: AccountBlock::DoctorPatientSerializer.new(@new_patient).serializable_hash
      else
        render json: {message: "record not found"}, status: :not_found
      end
    end

    def doctors_patient
      @doc_patient = current_doctor.patients
      if @doc_patient.present?
        render json: AccountBlock::DoctorPatientSerializer.new(@doc_patient, meta: {message: 'List of all patients'})
      else
        render json: {error: 'No patient found'}
      end
    end

    def update_doctor_patients
      doctor_patients = jsonapi_deserialize(params)
      @new_patient = AccountBlock::DoctorPatient.find(params[:id])
      if @new_patient.update(doctor_patients)
        render json: AccountBlock::DoctorPatientSerializer.new(@new_patient, meta: {
          message: 'new_patients Updated Successfully'}).serializable_hash, status: 200
      else
        render json: { message: @new_patient.errors.full_messages.to_sentence, status: 422 }, status: :unprocessable_entity
      end
    end

    def delete_doctor_patients
      @new_patient = AccountBlock::DoctorPatient.find(params[:id])
      if @new_patient.destroy
        render json: {status: true, message: "Deleted Successfully.", success: true}
      else
        render json: {status: true, message: "Unable to delete.", success: true}
      end
    end

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << { attribute => error }
      end
      result
    end
  end
end
