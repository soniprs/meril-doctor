module AccountBlock
  class ApplicationController < BuilderBase::ApplicationController
    # protect_from_forgery with: :exception
    include BuilderJsonWebToken::JsonWebTokenValidation


    rescue_from ActiveRecord::RecordNotFound, :with => :not_found

    private

    def not_found
      render :json => {'errors' => ['Record not found']}, :status => :not_found
    end
  end
end
