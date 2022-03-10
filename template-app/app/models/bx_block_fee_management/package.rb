module BxBlockFeeManagement
  class Package < ApplicationRecord
    self.table_name = :packages
    belongs_to :doctor, class_name: 'AccountBlock::Doctor'
    validates_presence_of :name,:consultation_fees,:sample_requirement

    enum sample_requirement: ["Blood","Serum","Plasma","Stool"]
  end
end
