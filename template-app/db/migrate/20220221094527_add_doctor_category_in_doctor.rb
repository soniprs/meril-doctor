class AddDoctorCategoryInDoctor < ActiveRecord::Migration[6.0]
  def change
      add_column :doctors, :doctor_category, :string
  end
end
