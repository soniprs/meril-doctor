module BxBlockMedicine
  class PrescriptionsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token
    before_action :set_patient, only: [:create]

    def create
      @prescription = BxBlockMedicine::Prescription.new(
        prescription_params.merge({ doctor_id: current_doctor.id,patient_id: @current_doctor_patient.id })
        )
      if @prescription.save
        if params[:image].present?
          @prescription.medicine_image.attach(data: params[:image][:data])
        end

        extra_information = {}
        if params[:add_extra_information].present?
          params[:add_extra_information].each do |key,value|
            extra_information = extra_information.merge("#{key}" => "#{value}")
          end
          @prescription.update({:add_extra_information => extra_information})
        end

        follow_up_consultation = {}
        if params[:follow_up_consultation].present?
          params[:follow_up_consultation].each do |key,value|
            follow_up_consultation = follow_up_consultation.merge("#{key}" => "#{value}")
          end
          @prescription.update({:follow_up_consultation => follow_up_consultation})
        end

        render json: BxBlockMedicine::PrescriptionSerializer.new(@prescription, meta: {
          message: 'prescription Created Successfully',
        }).serializable_hash, status: :created
      else
        render json: { errors: format_activerecord_errors(@prescription.errors) },
               status: :unprocessable_entity
      end
    end

    def show 
      @prescription = BxBlockMedicine::Prescription.find(params[:id])
      if @prescription
        render json: BxBlockMedicine::PrescriptionSerializer.new(@prescription).serializable_hash
      else
        render json: {message: "record not found"}, status: :not_found
      end
    end

    def update
      @prescription = BxBlockMedicine::Prescription.find(params[:id])
      if @prescription.update(prescription_params)
        if params[:image].present?
          @prescription.medicine_image.attach(data: params[:image][:data])
        end

        extra_information = {}
        if params[:add_extra_information].present?
          params[:add_extra_information].each do |key,value|
            extra_information = extra_information.merge("#{key}" => "#{value}")
          end
          @prescription.update({:add_extra_information => extra_information})
        end

        follow_up_consultation = {}
        if params[:follow_up_consultation].present?
          params[:follow_up_consultation].each do |key,value|
            follow_up_consultation = follow_up_consultation.merge("#{key}" => "#{value}")
          end
          @prescription.update({:follow_up_consultation => follow_up_consultation})
        end
        render json: BxBlockMedicine::PrescriptionSerializer.new(@prescription, meta: {
          message: 'prescription Updated Successfully'}).serializable_hash, status: 200
      else
        render json: { message: @prescription.errors.full_messages.to_sentence, status: 422 }, status: :unprocessable_entity
      end
    end

    def delete
      @prescription = BxBlockMedicine::Prescription.find(params[:id])
      if @prescription.destroy
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

    private

    def set_patient
      @current_doctor_patient = AccountBlock::DoctorPatient.find(params[:id])
    end
    def prescription_params
      params.permit(:medicine_name,:duration,:time,:comments,:doctor_id,:dose_time,:image,:patient_id,:add_extra_information,:follow_up_consultation)
    end
  end
end