module AccountBlock
  class FamilyMembersController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    include Rails.application.routes.url_helpers
    
    before_action :validate_json_web_token
    before_action :find_account, only: [:create_family_member,:get_family_member_list]
    
    def create_family_member
      family_member_params = jsonapi_deserialize(params)
      @family_members =  @patient.family_members
      @patient_family_member = @family_members.new(family_member_params)
      if @patient_family_member.save
        render json: FamilyMemberSerializer.new(@patient_family_member).serializable_hash, status: 200
      else
        render json: { message: @patient_family_member.errors.full_messages.to_sentence, status: 422 }, status: :unprocessable_entity
      end
    end
  

    def get_family_member_list
      @family_members =  @patient.family_members
      if @family_members.present?
        render json: FamilyMemberSerializer.new(@family_members, meta: {message: 'List of Family Members.'
        }).serializable_hash, status: :ok
      else
        render json: {errors: [{message: 'Not found any family member.'}]}, status: :ok
      end
    end

    def delete_family_member
      family_member = AccountBlock::FamilyMember.find(params[:id])
      if family_member&.destroy
        render json: {status: true, message: "Deleted Successfully.", success: true}
      else
        render json: {status: true, message: "Unable to delete.", success: true}
      end
      rescue ActiveRecord::RecordNotFound
        render json: {message: "Record not found.", success: false}
    end


    def update_family_member
      family_member_params = jsonapi_deserialize(params)
      @family = AccountBlock::FamilyMember.find(params[:id])
      if @family.update(family_member_params)
        render json: FamilyMemberSerializer.new(@family).serializable_hash, status: 200
      else
        render json: { message: @family.errors.full_messages.to_sentence, status: 422 }, status: :unprocessable_entity
      end
    end
    

    def upload_family_member_photo
     @family = AccountBlock::FamilyMember.find(params[:id])
      if @family.present?
        @family.family_member_photo.attach(params["family_member_photo"])
        @family.save
        family_image = @family.try(:family_member_photo)
        if @family.family_member_photo.present?
          render json: { status: 200, file_path: rails_blob_url(family_image) }
        else
          render json: {  status: 422, message: 'Family Member image not attached.' }, status: :unprocessable_entity
        end
      else
        render json: { message: 'Invalid data format', status: 422 }, status: :unprocessable_entity
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
      rescue ActiveRecord::RecordNotFound => e
        return render json: {errors: [
          {error: 'Patient Not Found'},
        ]}, status: :unprocessable_entity
    end

  end
end
