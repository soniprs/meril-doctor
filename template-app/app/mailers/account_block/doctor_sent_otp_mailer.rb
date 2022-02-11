module AccountBlock
  class DoctorSentOtpMailer < ApplicationMailer
    def activation_email_doctor
     @otp = params[:otp]
      @host = Rails.env.development? ? 'http://localhost:3000' : params[:host]
      mail(
          to: @otp.email,
          from: 'builder.bx_dev@engineer.ai',
          subject: 'Your OTP code') do |format|
        format.html { render 'activation_email_doctor' }
      end
    end
  end
end
