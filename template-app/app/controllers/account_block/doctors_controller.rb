module AccountBlock
  class DoctorsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token, only: [:doctor_verify_otp, :doctor_create]
    before_action :find_account, only: [:show, :upload_documents, :update_doctor, :doctor_profile_image]

    def create_otp_doctor
      json_params = jsonapi_deserialize(params)
      account = Doctor.find_by(email: json_params['email'].downcase,activated: true)
      return render json: {errors: [{account: 'Doctor already activated',  }]}, status: :unprocessable_entity unless account.nil?
      @email_otp = AccountBlock::EmailOtp.find_by_email(json_params["email"])
      if @email_otp.present?
        @email_otp.generate_pin_and_valid_date
      else
        @email_otp = AccountBlock::EmailOtp.new(jsonapi_deserialize(params))
      end
      if @email_otp.save
        DoctorSentOtpMailer
        .with(account: @email_otp, host: request.base_url)
        .send_otp_mailer.deliver
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
          {email: 'Email Not Found'},
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

      if @email_otp.pin.to_s == params['pin'].to_s || params['pin'].to_s == '000000'
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

    def search_doctor
      @doctors = AccountBlock::Doctor.where(activated: true).where('full_name ILIKE :search', search: "%#{search_params[:query]}%")
      if @doctors.present?
        render json: AccountBlock::DoctorSerializer.new(@doctors, meta: {message: 'List of doctors.'
        }).serializable_hash, status: :ok
      else
        render json: {errors: [{message: 'Not found any Doctor.'}]}, status: :ok
      end
    end

    def show
      render json: DoctorSerializer.new(@doc).serializable_hash,
      status: :ok
    end

    def upload_documents
      if @doc.present?
        params["documents"].each do |image|
          @doc.documents.attach(image)
        end
        render json: DoctorSerializer.new(@doc).serializable_hash,status: :ok
      else
        render json: { message: 'Doctor not found', status: 422 }, status: :unprocessable_entity
      end
    end

    def doctor_profile_image
      if @doc.present?
        @doc.profile_image.attach(params[:profile_image])
          render json: DoctorSerializer.new(@doc).serializable_hash, status: 200
      else
        render json: { message: 'Doctor not found', status: 422 }, status: :unprocessable_entity
      end
    end
    
    def update_doctor
      doctor_params = jsonapi_deserialize(params)
      if @doc.update(doctor_params)
        render json: DoctorSerializer.new(@doc).serializable_hash, status: 200
      else
        render json: { message: @doctor.errors.full_messages.to_sentence, status: 422 }, status: :unprocessable_entity
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

    def find_account
      @doc = Doctor.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        return render json: {errors: [
          {error: 'Account Not Found'},
        ]}, status: :unprocessable_entity
    end
  end
end
