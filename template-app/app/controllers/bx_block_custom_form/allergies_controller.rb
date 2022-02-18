module BxBlockCustomForm
  class AllergiesController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    include Rails.application.routes.url_helpers
    
    skip_before_action :validate_json_web_token
    before_action :find_account, only: [:create_allergy, :get_allergies_list]

    def create_allergy
      allergy_params = jsonapi_deserialize(params)
      @allergies =  @patient.allergies
      @patient_allergy = @allergies.new(allergy_params)
      if @patient_allergy.save
        render json: BxBlockCustomForm::AllergySerializer.new(@patient_allergy).serializable_hash, status: 200
      else
        render json: { message: @patient_allergy.errors.full_messages.to_sentence, status: 422 }, status: :unprocessable_entity
      end
    end


    def search_allergy
      
      @allergy = BxBlockCustomForm::Allergy.where('full_name ILIKE :search', search: "%#{search_params[:query]}%")
      if @allergy.present?
        render json: BxBlockCustomForm::AllergySerializer.new(@allergy, meta: {message: 'List of allergy.'
        }).serializable_hash, status: :ok
      else
        render json: {errors: [{message: 'Not found any Allergy.'}]}, status: :ok
      end
    end

    def get_allergies_list
      @allergies =  @patient.allergies
      if @allergies.present?
        render json: BxBlockCustomForm::AllergySerializer.new(@allergies, meta: {message: 'List of Allergies '
        }).serializable_hash, status: :ok
      else
        render json: {errors: [{message: 'Not found any Allergy.'}]}, status: :ok
      end
    end

    def delete_allergy
      allergy = BxBlockCustomForm::Allergy.find(params[:id])
      if allergy&.destroy
        render json: {status: true, message: "Deleted Successfully.", success: true}
      else
        render json: {status: true, message: "Unable to delete.", success: true}
      end
      rescue ActiveRecord::RecordNotFound
        render json: {message: "Record not found.", success: false}
    end


    def update_allergy
      allergy_params = jsonapi_deserialize(params)
      @allergy = BxBlockCustomForm::Allergy.find(params[:id])
      if @allergy.update(allergy_params)
        render json: AllergySerializer.new(@allergy).serializable_hash, status: 200
      else
        render json: { message: @allergy.errors.full_messages.to_sentence, status: 422 }, status: :unprocessable_entity
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

    def find_account
      @patient = AccountBlock::Patient.find(params[:id])
      if @patient.present?
       
       else
        render json: {errors: [{message: 'Not found any patient.'}]}, status: :ok
      end
    end


    def find_account
      @patient = AccountBlock::Patient.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        return render json: {errors: [
          {error: 'Patient Not Found'},
        ]}, status: :unprocessable_entity
    end


    def search_params
      params.permit(:query)
    end
  end
end
