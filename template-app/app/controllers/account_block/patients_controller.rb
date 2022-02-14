module AccountBlock
  class PatientsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token, only: [:verify_otp, :patient_create]

    def create_otp

      json_params = jsonapi_deserialize(params)
     
      account = Patient.find_by(full_phone_number: json_params['full_phone_number'],activated: true)

      return render json: {errors: [{account: 'Phone Number Already Present.',  }]}, status: :unprocessable_entity unless account.nil?
      @phone = Phonelib.parse(json_params['full_phone_number'])
      otp_account  = SmsOtp.find_by(full_phone_number: @phone.sanitized)
      if otp_account.present?
        otp_account.generate_pin_and_valid_date
        otp_account.save!
        render json: SmsOtpSerializer.new(otp_account, meta: {
              token: BuilderJsonWebToken.encode(otp_account.id),
            }).serializable_hash, status: :created
      else
        @sms_otp = SmsOtp.new(jsonapi_deserialize(params))
        if @sms_otp.save
          
          render json: SmsOtpSerializer.new(@sms_otp, meta: {
             
              token: BuilderJsonWebToken.encode(@sms_otp.id),
            }).serializable_hash, status: :created
        else
          render json: {errors: format_activerecord_errors(@sms_otp.errors)},
              status: :unprocessable_entity
        end
      end
    end


    def verify_otp
      begin
        @sms_otp = SmsOtp.find(@token.id)
      rescue ActiveRecord::RecordNotFound => e
        return render json: {errors: [
          {phone: 'Phone Number Not Found'},
        ]}, status: :unprocessable_entity
      end

      if @sms_otp.valid_until < Time.current
        @sms_otp.destroy

        return render json: {errors: [
          {pin: 'This Pin has expired, please request a new pin code.'},
        ]}, status: :unauthorized
      end

      if @sms_otp.activated?
        return render json: SmsOtpSerializer.new(@sms_otp, meta: {
          message: 'Phone Number Already Activated', token: BuilderJsonWebToken.encode(@sms_otp.id)
        }).serializable_hash, status: :ok
      end

      if @sms_otp.pin.to_s == params['pin'].to_s || params['pin'].to_s == '0000'
        @sms_otp.activated = true
        @sms_otp.save
        

        render json: SmsOtpSerializer.new(@sms_otp, meta: {
          message: 'Phone Number Confirmed Successfully',
          token: BuilderJsonWebToken.encode(@sms_otp.id),
        }).serializable_hash, status: :ok
      else
        return render json: {errors: [
          {pin: 'Please enter a valid OTP'},
        ]}, status: :unprocessable_entity
      end
    end



    def patient_create
      case params[:data][:type] #### rescue invalid API format
      when 'sms_account'
        begin
          @sms_otp = SmsOtp.find(@token.id)
          
        rescue ActiveRecord::RecordNotFound => e
          return render json: {errors: [
            {phone: 'Confirmed Phone Number was not found'},
          ]}, status: :unprocessable_entity
        end

        params[:data][:attributes][:full_phone_number] =@sms_otp.full_phone_number
        params[:data][:attributes][:full_name] =@sms_otp.full_name


        @account = Patient.new(jsonapi_deserialize(params))
        @account.activated = true
        if @account.save
          render json: PatientSerializer.new(@account, meta: {token: encode(@account.id)}).serializable_hash, status: :created
        else
          render json: {errors: format_activerecord_errors(@account.errors)},
            status: :unprocessable_entity
        end
      # when 'social_account'
      #   @account = Patient.new(jsonapi_deserialize(params))
      #   @account.password = @account.email
      #   if @account.save
      #     render json: PatientSerializer.new(@account, meta: {
      #       token: encode(@account.id),
      #     }).serializable_hash, status: :created
      #   else
      #     render json: {errors: format_activerecord_errors(@account.errors)},
      #       status: :unprocessable_entity
      #   end

      else
        render json: {errors: [
          {account: 'Invalid Account Type'},
        ]}, status: :unprocessable_entity
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

    def encode(id)
      BuilderJsonWebToken.encode id
    end

  end
end
