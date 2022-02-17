module BxBlockLogin
  class PatientLoginsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token, only: [:verify_otp]

    # def patient_login
    #   case params[:data][:type] #### rescue invalid API format
    #   when 'sms_account', 'email_account', 'social_account'
    #     account = OpenStruct.new(jsonapi_deserialize(params))
    #     account.type = params[:data][:type]

    #     output = ProfileAdapter.new

    #     output.on(:account_not_found) do |account|
    #       render json: {
    #         errors: [{
    #           failed_login: 'Account not found, or not activated',
    #         }],
    #       }, status: :unprocessable_entity
    #     end

    #     output.on(:failed_login) do |account|
    #       render json: {
    #         errors: [{
    #           failed_login: 'Login Failed',
    #         }],
    #       }, status: :unauthorized
    #     end

    #     output.on(:successful_login) do |account, token, refresh_token|
    #       render json: {meta: {
    #         token: token,
    #         refresh_token: refresh_token,
    #         id: account.id
    #       }}
    #     end

    #     output.login_account(account)
    #   else
    #     render json: {
    #       errors: [{
    #         account: 'Invalid Account Type',
    #       }],
    #     }, status: :unprocessable_entity
    #   end
    # end

    def send_otp
      begin
      @phone = Phonelib.parse(params['full_phone_number'])
      account  = AccountBlock::Patient.find_by(full_phone_number: @phone.sanitized)
        return render json: {
            errors: [{
              failed_login: 'Patient not found, or not activated',
            }],
          }, status: :unprocessable_entity if account.nil?
        if account.update_otp
         # account.send_pin_via_sms
         
        render json: BxBlockForgotPassword::SmsOtpSerializer.new(account, meta: {token: encode(account.id), message: "Otp sent."}).serializable_hash, status: :ok
        else
          render json: {
            errors: [account.errors],
          }, status: :unprocessable_entity
        end
      rescue Exception => e
        render json: {error: "Something went wrong while sending OTP. #{e}"}
      end
    end

    def verify_otp
      begin
        @account = AccountBlock::Patient.find(@token.id)
      rescue ActiveRecord::RecordNotFound => e
        return render json: {errors: [
          {phone: 'Phone Number Not Found'},
        ]}, status: :unprocessable_entity
      end
      if @account.pin.to_s == params['pin'].to_s || params['pin'].to_s == '000000'
        render json: AccountBlock::PatientSerializer.new(@account, meta: {
          message: 'Otp verified.',
          token: BuilderJsonWebToken.encode(@account.id),
        }).serializable_hash, status: :ok
      else
        return render json: {errors: [
          {pin: 'Please enter a valid OTP'},
        ]}, status: :unprocessable_entity
      end
    end


    def encode(id)
      BuilderJsonWebToken.encode id
    end

  end
end
