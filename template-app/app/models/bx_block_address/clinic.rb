module BxBlockAddress
  class Clinic < ApplicationRecord
    self.table_name = :clinics
    include ActiveStorageSupport::SupportForBase64
    belongs_to :doctor, class_name: 'AccountBlock::Doctor'
    has_many_base64_attached :clinic_images
  end
end
