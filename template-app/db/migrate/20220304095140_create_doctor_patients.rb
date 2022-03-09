class CreateDoctorPatients < ActiveRecord::Migration[6.0]
  def change
    create_table :doctor_patients do |t|
      t.string :full_name
      t.string :full_phone_number
      t.date :date_of_birth
      t.decimal :weight
      t.string :city
      t.string :blood_group
      t.text :diseases
      t.integer :doctor_id
      t.string :patient_health_id
      t.timestamps
    end
  end
end
