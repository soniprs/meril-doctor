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
      :doctor_category,
      :pin,
    ]

    attributes :profile_image do |object|
      if object.profile_image.attached?
        Rails.application.routes.url_helpers.rails_blob_url(object.profile_image, only_path: true)
      else
        ''
      end
    end

    attribute :identity_details do |object|
      if object.identity_details.attached?
        object.identity_details.map { |image|
          Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true )
        }
      end
    end

    attribute :degree_deatils do |object|
      if object.degree_deatils.attached?
        object.degree_deatils.map { |image|
          Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true )
        }
      end
    end

    attribute :registration_details do |object|
      if object.registration_details.attached?
        object.registration_details.map { |image|
          Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true )
        }
      end
    end

    attribute :clinic_details do |object|
      if object.clinic_details.attached?
        object.clinic_details.map { |image|
          Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true )
        }
      end
    end

    attributes :doctor_id do |object|  
      object.id
    end

    attributes :text_size do |object|
      object.privacy_setting.text_size
    end

    attributes :mode do |object|
      object.privacy_setting.mode
    end

  end
end