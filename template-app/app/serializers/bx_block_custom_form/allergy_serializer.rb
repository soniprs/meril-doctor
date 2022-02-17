module BxBlockCustomForm
  class AllergySerializer
    include FastJsonapi::ObjectSerializer
    include Rails.application.routes.url_helpers

    attributes *[      
      :full_name,   
    ]
    
  end
end