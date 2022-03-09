module AccountBlock
  class DoctorPatientSerializer < BuilderBase::BaseSerializer
    attributes *[
      :full_name,
      :full_phone_number,
      :date_of_birth,
      :weight,
      :city,
      :blood_group,
      :diseases,
      :doctor_id,
      :patient_health_id,      
    ]
  end
end
