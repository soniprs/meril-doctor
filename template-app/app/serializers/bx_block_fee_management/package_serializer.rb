module BxBlockFeeManagement
  class PackageSerializer
    include FastJsonapi::ObjectSerializer

    attributes *[
      :name,
      :no_of_tests,
      :description,
      :duration,
      :consultation_fees,
      :sample_requirement,
      :doctor_id,
    ]
  end
end