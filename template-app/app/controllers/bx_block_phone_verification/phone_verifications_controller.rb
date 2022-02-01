module BxBlockPhoneVerification
  class PhoneVerificationsController < ApplicationController

    def send_sms_otp
      json_params = jsonapi_deserialize(params)
      account = AccountBlock::Account.find_by(
        full_phone_number: json_params['full_phone_number'])

      return render json: {errors: [{
        account: 'Account not found',
      }]}, status: :not_found if account.nil?

      return render json: {errors: [{
        account: 'Account already activated',
      }]}, status: :unprocessable_entity if account.activated

      sms_otp = AccountBlock::SmsOtp.new(json_params)
      if sms_otp.save
        render json: {token: BuilderJsonWebToken.encode(sms_otp.id),
                      message: "Send otp successfully"}, status: :ok
      else
        render json: {errors: format_activerecord_errors(sms_otp.errors)},
          status: :unprocessable_entity
      end
    end

    def verify_sms_otp
      validate_json_web_token
      begin
        sms_otp = AccountBlock::SmsOtp.find(@token.id)
      rescue ActiveRecord::RecordNotFound => e
        return render json: {errors: [
          {phone: 'Phone Number Not Found'},
        ]}, status: :unprocessable_entity
      end

      if sms_otp.valid_until < Time.current
        sms_otp.destroy

        return render json: {errors: [
          {pin: 'This Pin has expired, please request a new pin code.'},
        ]}, status: :unauthorized
      end

      if sms_otp.activated?
        return render json: {errors: [
          { message: 'Phone Number Already Activated.'}
        ]}, status: :unprocessable_entity
      end

      if sms_otp.pin.to_s == params['pin']
        sms_otp.activated = true
        sms_otp.save
        account = AccountBlock::Account.find_by(full_phone_number: sms_otp.full_phone_number)
        account.update(activated: true)
        token = BuilderJsonWebToken.encode(account.id)
        render json: {token: token, is_activated: account&.activated, message: "Login Successful"}
      else
        return render json: {errors: [
          {pin: 'Invalid Pin for Phone Number'},
        ]}, status: :unprocessable_entity
      end
    end
  end
end
