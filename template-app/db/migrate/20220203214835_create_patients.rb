class CreatePatients < ActiveRecord::Migration[6.0]
  def change
    create_table :patients do |t|
      t.string :first_name
      t.string :last_name
      t.string :email_id
      t.string :full_phone_number
      t.date   :date_of_birth
      t.string :gender
      t.decimal :weight
      t.string  :blood_group
      t.string :city
      t.string   :aadhar_no
      t.string :health_id
      t.string :ayushman_bharat_id
      t.string :disease
      t.boolean :activated, :null => false, :default => false
      t.string :full_name
      t.integer :pin
      t.timestamps
    end
  end
end
