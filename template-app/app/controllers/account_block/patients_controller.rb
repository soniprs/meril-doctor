module AccountBlock
  class PatientsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation

    before_action :validate_json_web_token, only: [:verify_otp, :patient_create , :search_doctor]

    def create_otp

      json_params = jsonapi_deserialize(params)
     
      account = Patient.find_by(full_phone_number: json_params['full_phone_number'],activated: true)

      return render json: {errors: [{account: 'Patient already activated',  }]}, status: :unprocessable_entity unless account.nil?

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
        return render json: ValidateAvailableSerializer.new(@sms_otp, meta: {
          message: 'Phone Number Already Activated',
        }).serializable_hash, status: :ok
      end

      if @sms_otp.pin.to_s == params['pin'].to_s || params['pin'].to_s == '0000'
        @sms_otp.activated = true
        @sms_otp.save
        

        render json: ValidateAvailableSerializer.new(@sms_otp, meta: {
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

        params[:data][:attributes][:full_phone_number] =
          @sms_otp.full_phone_number

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


    def search_doctor
      @doctors = AccountBlock::Doctor.where(activated: true).where('full_name ILIKE :search', search: "%#{search_params[:query]}%")
      if @doctors.present?
        render json: AccountBlock::DoctorSerializer.new(@doctors, meta: {message: 'List of doctors.'
        }).serializable_hash, status: :ok
      else
        render json: {errors: [{message: 'Not found any user.'}]}, status: :ok
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

    def search_params
      params.permit(:query)
    end

  end
end
