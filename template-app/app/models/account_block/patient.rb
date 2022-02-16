module AccountBlock
  class Patient < ApplicationRecord
    self.table_name = :patients
    validates :full_phone_number, presence: true,uniqueness: true
    has_one_attached :image

    def update_otp
      update(pin: rand(1_000..9_999))
    end

    def send_pin_via_sms
      message = "Your Pin Number is #{self.pin}"
    #  txt     = BxBlockSms::SendSms.new("+#{self.full_phone_number}", message)
    #  txt.call
    end
  end
end
