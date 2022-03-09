module AccountBlock
  class DoctorPatient < ApplicationRecord
    self.table_name = :doctor_patients
    belongs_to :doctor,class_name: "AccountBlock::Doctor"
    serialize :diseases, Array

    after_create :create_patient_id

    def create_patient_id
      self.patient_health_id = rand(1_000000000..9_999999999)
    end
  end
end
