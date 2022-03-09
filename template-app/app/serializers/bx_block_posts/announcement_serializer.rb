module BxBlockPosts
  class AnnouncementSerializer < BuilderBase::BaseSerializer

    attributes *[
        :id,
        :title,
        :description,
        :tags,
        :doctor_id,
    ]

    attribute :image do |object|
      Rails.application.routes.url_helpers.rails_blob_url(object.avatar, only_path: true) if object.avatar.attached?
    end

  end
end