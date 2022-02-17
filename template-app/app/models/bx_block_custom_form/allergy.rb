module BxBlockCustomForm
  class Allergy < ApplicationRecord
    self.table_name = :allergies
    belongs_to :patient,class_name: 'AccountBlock::Patient'
  end
end