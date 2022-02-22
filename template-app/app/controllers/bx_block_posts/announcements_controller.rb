module BxBlockPosts
  class AnnouncementsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token
    before_action :find_account, only: [:create, :show]

    def create
      announcement = @doctor.announcements
      @announcement = announcement.new(announcement_params)
      if @announcement.save
        if params["data"]["image"].present? 
          @announcement.avatar.attach(data: params["data"]["image"]["data"])
        end   
        render json: BxBlockPosts::AnnouncementSerializer.new(@announcement).serializable_hash, status: 200
      else
        render json: { message: @announcement.errors.full_messages.to_sentence, status: 422 }, status: :unprocessable_entity
      end
    end

    def show
      @announcement = @doctor.announcements
      if @announcement.present?
        render json: AnnouncementSerializer.new(@announcement).serializable_hash
      else
        render json: {error: "no announcement found"}, status: :not_found
      end
    end

    def update
      @announcement = BxBlockPosts::Announcement.find(params[:id])
      if @announcement.update(announcement_params)
        render json: AnnouncementSerializer.new(@announcement).serializable_hash, status: 200
      else
        render json: { message: @announcement.errors.full_messages.to_sentence, status: 422 }, status: :unprocessable_entity
      end
    end

    def delete
      @announcement = BxBlockPosts::Announcement.find(params[:id])
      if @announcement.destroy
        render json: {status: true, message: "Deleted Successfully.", success: true}
      else
        render json: {status: true, message: "Unable to delete.", success: true}
      end
      rescue ActiveRecord::RecordNotFound
        render json: {message: "Record not found.", success: false}
    end
   
    private
    def find_account
      @doctor = AccountBlock::Doctor.find(@token.id)
      rescue ActiveRecord::RecordNotFound => e
        return render json: {errors: [
          {error: 'Doctor Not Found'},
        ]}, status: :unprocessable_entity
    end

    def announcement_params
      params.require(:data).permit(:title,:description,:tags,:status,:image,:doctor_id)
    end
  end
end
