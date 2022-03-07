class CreateClinics < ActiveRecord::Migration[6.0]
  def change
    create_table :clinics do |t|
      t.string :name
      t.string :address
      t.string :contact_no
      t.string :link
      t.integer :doctor_id
      t.timestamps
    end
  end
end
