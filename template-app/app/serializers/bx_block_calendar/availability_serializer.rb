module BxBlockCalendar
  class AvailabilitySerializer< BuilderBase::BaseSerializer

    attributes *[:start_time,
                 :end_time,
                 :doctor_id,
                 :mode_type,
                 :day_of_week,
    ]
  end
end
