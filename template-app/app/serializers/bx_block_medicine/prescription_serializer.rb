module BxBlockMedicine
  class PrescriptionSerializer < BuilderBase::BaseSerializer

    attributes *[
      :medicine_name,
      :duration,
      :time,
      :comments,
      :doctor_id,
      :dose_time,
      :patient_id,
      :doctor_id,
      :add_extra_information,
      :follow_up_consultation,
    ]

    attribute :image do |object|
      Rails.application.routes.url_helpers.rails_blob_url(object.medicine_image, only_path: true) if object.medicine_image.attached?
    end
  end
end
