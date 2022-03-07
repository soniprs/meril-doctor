module AccountBlock
  class Patient < ApplicationRecord
    self.table_name = :patients
    validates :full_phone_number, presence: true,uniqueness: true
    has_many :patients, class_name: "AccountBlock::Patient",foreign_key: "parent_patient_id"
    has_one_attached :profile_photo
    has_many :family_members
    has_one :privacy_setting, class_name: 'BxBlockSettings::PrivacySetting', dependent: :destroy
    has_many :allergies,class_name: 'BxBlockCustomForm::Allergy',dependent: :destroy
    after_create :create_privacy_setting

    def update_otp
      update(pin: rand(1_00000..9_99999))
    end

    def send_pin_via_sms
      message = "Your Pin Number is #{self.pin}"
    #  txt     = BxBlockSms::SendSms.new("+#{self.full_phone_number}", message)
    #  txt.call
    end

    private
    def create_privacy_setting
      BxBlockSettings::PrivacySetting.create!(patient_id: self.id,language: "English",mode: 0,doctor_id: nil)
    end
  end
end