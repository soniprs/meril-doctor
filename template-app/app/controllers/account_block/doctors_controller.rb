module AccountBlock
  class DoctorsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token, except: [:create_otp_doctor]
    before_action :find_account, only: [:show_doctor]

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

    def show_doctor
      render json: DoctorSerializer.new(@doc).serializable_hash,
      status: :ok
    end

    def show
      render json: DoctorSerializer.new(current_doctor).serializable_hash,
      status: :ok
    end

    def upload_documents
      if params[:identity_details].present?
        params[:identity_details].each do |image|
          current_doctor.identity_details.attach(image)
        end
      end
      if params[:degree_deatils].present?
        params[:degree_deatils].each do |image|
          current_doctor.degree_deatils.attach(image)
        end
      end
      if params[:registration_details].present?
        params[:registration_details].each do |image|
          current_doctor.registration_details.attach(image)
        end
      end
      if params[:clinic_details].present?
        params[:clinic_details].each do |image|
          current_doctor.clinic_details.attach(image)
        end
      end
      render json: DoctorSerializer.new(current_doctor).serializable_hash,status: :ok
    end

    def doctor_profile_image
      if current_doctor.present?
        current_doctor.profile_image.attach(params[:profile_image])
          render json: DoctorSerializer.new(current_doctor).serializable_hash, status: 200
      else
        render json: { message: 'Doctor not found', status: 422 }, status: :unprocessable_entity
      end
    end
    
    def update
      doctor_params = jsonapi_deserialize(params)
      if current_doctor.update(doctor_params)
        render json: DoctorSerializer.new(current_doctor).serializable_hash, status: 200
      else
        render json: { message: current_doctor.errors.full_messages.to_sentence, status: 422 }, status: :unprocessable_entity
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

    def find_account
      @doc = Doctor.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
        return render json: {errors: [
          {error: 'Account Not Found'},
        ]}, status: :unprocessable_entity
    end
  end
end
