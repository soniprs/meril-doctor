class AddColumnToAvailablity < ActiveRecord::Migration[6.0]
  def change
    add_column :availabilities, :doctor_id, :integer
    add_column :availabilities, :day_of_week, :text
    add_column :availabilities, :mode_type, :integer
  end
end
