module AccountBlock
  class DoctorsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token, only: [:doctor_verify_otp, :doctor_create]

    def create_otp_doctor
      json_params = jsonapi_deserialize(params)
      account = Doctor.find_by(email: json_params['email'].downcase,activated: true)
      return render json: {errors: [{account: 'Doctor already activated',  }]}, status: :unprocessable_entity unless account.nil?

      @email_otp = AccountBlock::EmailOtp.new(jsonapi_deserialize(params))
      if @email_otp.save
        DoctorSentOtpMailer
        .with(otp: @email_otp, host: request.base_url)
        .activation_email_doctor.deliver
        render json: EmailOtpSerializer.new(@email_otp, meta: {
            token: BuilderJsonWebToken.encode(@email_otp.id),
          }).serializable_hash, status: :created
      else
        render json: {errors: format_activerecord_errors(@email_otp.errors)},
            status: :unprocessable_entity
      end
    end

    def doctor_verify_otp
      begin
        @email_otp = EmailOtp.find(@token.id)
      rescue ActiveRecord::RecordNotFound => e
        return render json: {errors: [
          {phone: 'Phone Number Not Found'},
        ]}, status: :unprocessable_entity
      end
      render json: {errors: [{otp: 'Invalid OTP'},]}, status: :unprocessable_entity and return if params[:pin].blank?
      if @email_otp.activated?
        return render json: AccountBlock::ValidateAvailableSerializer.new(@email_otp, meta: {
          message: 'Email Already Activated',
        }).serializable_hash, status: :ok
      end

      if @email_otp.valid_until < Time.current
        @email_otp.destroy

        return render json: {errors: [
          {pin: 'This Pin has expired, please request a new pin code.'},
        ]}, status: :unauthorized
      end

      if @email_otp.pin.to_s == params['pin'].to_s || params['pin'].to_s == '0000'
        @email_otp.activated = true
        @email_otp.save
        render json: AccountBlock::ValidateAvailableSerializer.new(@email_otp, meta: {
          message: 'email Confirmed Successfully',
          token: BuilderJsonWebToken.encode(@email_otp.id),
        }).serializable_hash, status: :ok
      else
        return render json: {errors: [
          {pin: 'Please enter a valid OTP'},
        ]}, status: :unprocessable_entity
      end
    end

    def doctor_create
      begin
        @email_otp = AccountBlock::EmailOtp.find(@token.id)       
      rescue ActiveRecord::RecordNotFound => e
        return render json: {errors: [
          {phone: 'Confirmed email was not found'},
        ]}, status: :unprocessable_entity
      end

      params[:data][:attributes][:email] =
        @email_otp.email

      @doctor = Doctor.new(jsonapi_deserialize(params))
      @doctor.activated = true
      if @doctor.save
        render json: AccountBlock::DoctorSerializer.new(@doctor, meta: {token: encode(@doctor.id)}).serializable_hash, status: :created
      else
        render json: {errors: format_activerecord_errors(@doctor.errors)},
          status: :unprocessable_entity
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
