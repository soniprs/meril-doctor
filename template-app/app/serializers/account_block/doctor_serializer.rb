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
      :experience,
      :pin,
    ]

    attributes :profile_image do |object|
      if object.profile_image.attached?
        Rails.application.routes.url_helpers.rails_blob_url(object.profile_image, only_path: true)
      else
        ''
      end
    end

    attribute :documents do |object|
      if object.documents.attached?
        object.documents.map { |image|
          Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true )
        }
      end
    end
  end
end