module BxBlockPosts
  class AnnouncementsController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token

    def create
      @announcement = BxBlockPosts::Announcement.new(announcement_params.merge(doctor_id: current_doctor.id))
      if @announcement.save
        if params["data"]["image"].present? 
          @announcement.avatar.attach(data: params["data"]["image"]["data"])
        end
        array = []
        if params[:data][:tags].present?
          announcement = params[:data][:tags]
          announcement.each do |ab|
            array << ab
          end
          @announcement.update({:tags => array})
        end   
        render json: BxBlockPosts::AnnouncementSerializer.new(@announcement).serializable_hash, status: 200
      else
        render json: { message: @announcement.errors.full_messages.to_sentence, status: 422 }, status: :unprocessable_entity
      end
    end

    def show
      render json: AnnouncementSerializer.new(current_doctor.announcements).serializable_hash
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
    end
   
    def announcement_params
      params.require(:data).permit(:title,:description,:status,:image,:doctor_id)
    end
  end
end
