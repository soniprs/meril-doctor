module AccountBlock
  class Doctor < ApplicationRecord
    self.table_name = :doctors
    validates :email, presence: true,uniqueness: true
    has_one_attached :profile_image
    has_many_attached :documents
    
    def update_otp
      update(pin: rand(1_000..9_999))
    end
  end
end
