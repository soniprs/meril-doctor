module BxBlockMedicine
  class Prescription < ApplicationRecord
    self.table_name = :prescriptions
    include ActiveStorageSupport::SupportForBase64
    belongs_to :doctor,class_name: "AccountBlock::Doctor"
    belongs_to :patient,class_name: "AccountBlock::DoctorPatient"
    has_one_base64_attached :medicine_image

    serialize :add_extra_information, Hash
    serialize :follow_up_consultation, Hash
  end
end
