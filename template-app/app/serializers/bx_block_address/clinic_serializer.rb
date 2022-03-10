module BxBlockAddress
  class ClinicSerializer < BuilderBase::BaseSerializer

    attributes *[
      :name,
      :address,
      :contact_no,
      :doctor_id,
      :link
    ]

    attribute :clinic_images do |object|
      if object.clinic_images.attached?
        object.clinic_images.map { |image|
          Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true )
        }
      end
    end
  end
end
