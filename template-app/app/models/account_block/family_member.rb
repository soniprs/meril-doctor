module AccountBlock
  class FamilyMember < ApplicationRecord
    self.table_name = :family_members
    belongs_to :patient
    has_one_attached :family_member_photo
  end
end
