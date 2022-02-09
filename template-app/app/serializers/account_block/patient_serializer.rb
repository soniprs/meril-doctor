module AccountBlock
  class PatientSerializer
    include FastJsonapi::ObjectSerializer

    attributes *[
      :first_name,
      :last_name,
      :full_name,
      :full_phone_number,
      :email_id,
      :date_of_birth,
      :gender,
      :weight,
      :blood_group,
      :city,
      :aadhar_no,
      :health_id,
      :ayushman_bharat_id,
      :disease,

    ]
  end
end