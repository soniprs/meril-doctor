module BxBlockFeeManagement
  class PackagesController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token

    def create_package
      @package = BxBlockFeeManagement::Package.new(
        package_params.merge({ doctor_id: current_doctor.id })
        )
      if @package.save
        render json: BxBlockFeeManagement::PackageSerializer.new(@package, meta: {
          message: 'package Created Successfully',
        }).serializable_hash, status: :created
      else
        render json: { errors: format_activerecord_errors(@package.errors) },
               status: :unprocessable_entity
      end
    end

    def show_package 
      @package = BxBlockFeeManagement::Package.find(params[:id])
      if @package
        render json: BxBlockFeeManagement::PackageSerializer.new(@package).serializable_hash
      else
        render json: {message: "record not found"}, status: :not_found
      end
    end

    def show 
      render json: BxBlockFeeManagement::PackageSerializer.new(current_doctor.packages).serializable_hash
    end

    def update_package
      @package = BxBlockFeeManagement::Package.find(params[:id])
      if @package.update(package_params)
        render json: BxBlockFeeManagement::PackageSerializer.new(@package, meta: {
          message: 'packages Updated Successfully'}).serializable_hash, status: 200
      else
        render json: { message: @package.errors.full_messages.to_sentence, status: 422 }, status: :unprocessable_entity
      end
    end

    def delete_package
      @package = BxBlockFeeManagement::Package.find(params[:id])
      if @package.destroy
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
    def package_params
      params.permit(:name,:no_of_tests,:consultation_fees,:description,:sample_requirement,:duration,:doctor_id)
    end
  end
end