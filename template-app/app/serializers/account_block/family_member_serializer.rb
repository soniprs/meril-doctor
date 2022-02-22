module AccountBlock
  class FamilyMemberSerializer
    include FastJsonapi::ObjectSerializer
    include Rails.application.routes.url_helpers

    attributes *[      
      :full_name,   
      :date_of_birth,
      :gender,
      :relation,
      :blood_group,
      :weight
    ]

    attributes :family_member_photo do |object|
      if object.family_member_photo.attached?
        @host = Rails.env.development? ? 'http://localhost:3000' : 'https://meril-101378-ruby.b101378.dev.eastus.az.svc.builder.cafe'
        @host + Rails.application.routes.url_helpers.rails_blob_url(object.family_member_photo, only_path: true)
      else
        ''
      end
    end
    
  end
end