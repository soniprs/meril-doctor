module AccountBlock
  class Doctor < ApplicationRecord
    self.table_name = :doctors
    validates :email, presence: true,uniqueness: true
    has_one_attached :profile_image
    has_many_attached :identity_details
    has_many_attached :degree_deatils
    has_many_attached :registration_details
    has_many_attached :clinic_details
    has_many :announcements, class_name: 'BxBlockPosts::Announcement'
    
    def update_otp
      update(pin: rand(1_00000..9_99999))
    end
  end
end
