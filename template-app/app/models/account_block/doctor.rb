module AccountBlock
  class Doctor < ApplicationRecord
    self.table_name = :doctors
    validates :email, presence: true,uniqueness: true
    has_one_attached :profile_image
    has_many_attached :identity_details
    has_many_attached :degree_deatils
    has_many_attached :registration_details
    has_many_attached :clinic_details
    has_many :announcements, class_name: 'BxBlockPosts::Announcement',dependent: :destroy
    has_many :availabilities, class_name: 'BxBlockAppointmentManagement::Availability',dependent: :destroy
    has_one :privacy_setting,class_name: 'BxBlockSettings::PrivacySetting',dependent: :destroy
    after_create :create_privacy_setting
    has_many :packages, class_name: 'BxBlockFeeManagement::Package',dependent: :destroy
    has_many :patients, class_name: 'AccountBlock::DoctorPatient',dependent: :destroy

    def update_otp
      update(pin: rand(1_00000..9_99999))
    end

    private
    
    def create_privacy_setting
      BxBlockSettings::PrivacySetting.create!(doctor_id: self.id,text_size: "17",mode: 0,patient_id: nil)
    end

  end
end
