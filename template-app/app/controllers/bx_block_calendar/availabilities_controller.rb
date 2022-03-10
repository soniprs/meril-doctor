module BxBlockCalendar
  class AvailabilitiesController < ApplicationController
    include BuilderJsonWebToken::JsonWebTokenValidation
    before_action :validate_json_web_token

    def create
      availability = BxBlockAppointmentManagement::Availability.new(
        availability_detail.merge({ doctor_id: current_doctor.id }))
      if availability.save
        array = []
        if params[:day_of_week].present?
          abc = params[:day_of_week]
          abc.each do |ab|
            array << ab
          end
          availability.update({:day_of_week => array})
        end
        render json: BxBlockCalendar::AvailabilitySerializer.new(availability).serializable_hash, status: :created
      else
        render json: { errors: format_activerecord_errors(availability.errors) },
               status: :unprocessable_entity
      end
    end

    def update
      availability = BxBlockAppointmentManagement::Availability.find(params[:id])
      if availability.update(availability_detail)
        array = []
        if params[:availability][:day_of_week].present?
          abc = params[:availability][:day_of_week]
          abc.each do |ab|
            array << ab
          end
          availability.update({:day_of_week => array})
        end
        render json: BxBlockCalendar::AvailabilitySerializer.new(availability).serializable_hash, status: 200
      else
        render json: { message: availability.errors.full_messages.to_sentence, status: 422 }, status: :unprocessable_entity
      end
    end
    
    def show
      @availability = BxBlockAppointmentManagement::Availability.find(params[:id])
      if @availability
        render json: BxBlockCalendar::AvailabilitySerializer.new(@availability).serializable_hash
      else
        render json: {message: "record not found"}, status: :not_found
      end
    end

    def doctor_availiablity 
      render json: BxBlockCalendar::AvailabilitySerializer.new(
      current_doctor.availabilities, meta: {message: 'List of all availability'}
    )
    end

    def delete
      @availability = BxBlockAppointmentManagement::Availability.find(params[:id])
      if @availability.destroy
        render json: {status: true, message: "Deleted Successfully.", success: true}
      else
        render json: {status: true, message: "Unable to delete.", success: true}
      end
    end

    private
    def availability_detail
      params.require(:availability).permit(:start_time, :end_time, :mode_type,:doctor_id)
    end

    def format_activerecord_errors(errors)
      result = []
      errors.each do |attribute, error|
        result << { attribute => error }
      end
      result
    end
  end
end
