module AccountBlock
  class Doctor < ApplicationRecord
    self.table_name = :doctors
    validates :email, presence: true,uniqueness: true

    def update_otp
      update(pin: rand(1_000..9_999))
    end
  end
end
