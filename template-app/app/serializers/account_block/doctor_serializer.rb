module AccountBlock
  class DoctorSerializer
    include FastJsonapi::ObjectSerializer

    attributes *[
      :first_name,
      :last_name,
      :full_name,
      :full_phone_number,
      :email,
      :registration_no,
      :registration_council,
      :year,
      :specialization,
      :city,
      :medical_representative_name,
      :representative_contact_no,
      :image,
      :experience,
      :pin,

    ]
  end
end