module AccountBlock
  class EmailOtpSerializer < BuilderBase::BaseSerializer
    attributes :email, :activated, :created_at
    attributes :pin
  end
end
