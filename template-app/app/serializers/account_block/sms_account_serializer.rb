module AccountBlock
  class SmsAccountSerializer
    include FastJsonapi::ObjectSerializer

    attributes *[
      :first_name,
      :last_name,
      :full_phone_number,
      :email,
      :activated,
    ]
  end
end
