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
        @host = Rails.env.development? ? 'http://localhost:3000' : 'https://meril-101378-ruby.b101378.dev.eastus.az.svc.builder.cafe'
        @host + Rails.application.routes.url_helpers.rails_blob_url(object.profile_image, only_path: true)
      else
        ''
      end
    end

  end
end