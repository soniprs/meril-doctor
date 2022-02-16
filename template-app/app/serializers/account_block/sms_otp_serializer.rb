module AccountBlock
  class SmsOtpSerializer < BuilderBase::BaseSerializer
  	attributes *[
      :full_phone_number,
      :pin,
      :valid_until,
      :full_name,
      :activated
    ]
  end
end
