module AccountBlock
  class PatientSerializer
    include FastJsonapi::ObjectSerializer
    include Rails.application.routes.url_helpers

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

    attributes :profile_photo do |object|
      if object.profile_photo.attached?
        # @host = Rails.env.development? ? 'http://localhost:3000' : 'https://meril-101378-ruby.b101378.dev.eastus.az.svc.builder.cafe'
        # @host + Rails.application.routes.url_helpers.rails_blob_url(object.profile_photo, only_path: true)
        Rails.application.routes.url_helpers.rails_blob_url(object.profile_photo, only_path: true)
      else
        ''
      end
    end
    
  end
end