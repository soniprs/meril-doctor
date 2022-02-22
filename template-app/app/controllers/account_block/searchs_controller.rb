module AccountBlock
  class SearchsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token

    def search_doctor
      @doctors = AccountBlock::Doctor.where('full_name ILIKE :search', search: "%#{search_params[:query]}%")
      if @doctors.present?
        render json: AccountBlock::DoctorSerializer.new(@doctors, meta: {message: 'List of doctors.'
        }).serializable_hash, status: :ok
      else
        render json: {errors: [{message: 'Not found any Doctor.'}]}, status: :ok
      end
    end

    def search_doctor_categorywise
      @doctors = AccountBlock::Doctor.where('doctor_category ILIKE :search', search: "%#{search_params[:query]}%")
      if @doctors.present?
        render json: AccountBlock::DoctorSerializer.new(@doctors, meta: {message: 'List of doctors.'
        }).serializable_hash, status: :ok
      else
        render json: {errors: [{message: 'Not found any Doctor.'}]}, status: :ok
      end
    end

    private

    def search_params
      params.permit(:query)
    end

  end
end