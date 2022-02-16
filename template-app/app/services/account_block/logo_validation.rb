module AccountBlock
  class LogoValidation
    include ActiveModel::Validations
    attr_reader :image

    # validates :avatar,  presence: :true
    validate :custom_validate
    validate :image_size


    def image_size
      return unless @logo.size > 5.megabytes
      errors.add(:image, 'should not be greater than 5 mb')
    end

    def initialize(params)
      @logo = params["image"]
    end

    def custom_validate
      errors.add :base, "Only jpg and png allowed." unless [".jpeg", ".jpg", ".png"].include?(File.extname(@logo)) if @logo.present?
    end
  end
end