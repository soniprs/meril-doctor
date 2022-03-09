module BxBlockAddress
  class ClinicsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token

    def create
      @clinic = BxBlockAddress::Clinic.new(
        clinic_params.merge({ doctor_id: current_doctor.id })
        )
      if @clinic.save
        if params[:images].present?
          params[:images].each do |image|
            @clinic.clinic_images.attach(data: image)
          end
        end
        render json: BxBlockAddress::ClinicSerializer.new(@clinic, meta: {
          message: 'clinic Created Successfully',
        }).serializable_hash, status: :created
      else
        render json: { errors: format_activerecord_errors(@clinic.errors) },
               status: :unprocessable_entity
      end
    end

    def show 
      @clinic = BxBlockAddress::Clinic.find(params[:id])
      if @clinic
        render json: BxBlockAddress::ClinicSerializer.new(@clinic).serializable_hash
      else
        render json: {message: "record not found"}, status: :not_found
      end
    end

    def update
      @clinic = BxBlockAddress::Clinic.find(params[:id])
      if @clinic.update(clinic_params)
        if params[:images].present?
          params[:images].each do |i|
            @clinic.clinic_images.attach(data: i)
          end
        end
        render json: BxBlockAddress::ClinicSerializer.new(@clinic, meta: {
          message: 'clinics Updated Successfully'}).serializable_hash, status: 200
      else
        render json: { message: @clinic.errors.full_messages.to_sentence, status: 422 }, status: :unprocessable_entity
      end
    end

    def delete
      @clinic = BxBlockAddress::Clinic.find(params[:id])
      if @clinic.destroy
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
    def clinic_params
      params.permit(:name,:address,:contact_no,:link,:doctor_id)
    end
  end
end