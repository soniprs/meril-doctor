module AccountBlock
  class DoctorSentOtpMailer < ApplicationMailer
    def activation_email_doctor
     @otp = params[:otp]
      @host = Rails.env.development? ? 'http://localhost:3000' : params[:host]

      token = encoded_token

      @url = "#{@host}/account/accounts/email_confirmation?token=#{token}"
      
      mail(
          to: @otp.email,
          from: 'dev.merillife@gmail.com',
          subject: 'Your OTP code') do |format|
        format.html { render 'activation_email_doctor' }
      end
    end

    def send_otp_mailer
      @account = params[:account]
      @pin = @account.pin
      mail(:to => "<#{@account.email}>", :subject => "Account OTP Code")
    end

    private

    def encoded_token
      BuilderJsonWebToken.encode @account.id, 10.minutes.from_now
    end
  end
end
