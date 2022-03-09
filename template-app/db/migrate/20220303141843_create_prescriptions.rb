class CreatePrescriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :prescriptions do |t|
      t.string :medicine_name
      t.string  :duration
      t.string :time
      t.text :comments
      t.string :dose_time
      t.integer :doctor_id
      t.integer :patient_id
      t.text :add_extra_information
      t.text :follow_up_consultation
      t.timestamps
    end
  end
end
