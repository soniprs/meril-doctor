class CreateDoctors < ActiveRecord::Migration[6.0]
  def change
    create_table :doctors do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :full_phone_number
      t.date   :registration_no
      t.string :registration_council
      t.date :year
      t.string  :specialization
      t.string :city
      t.string :medical_representative_name
      t.string :representative_contact_no
      t.string :experience
      t.binary :image
      t.boolean :activated, :null => false, :default => false
      t.string :full_name
      t.integer :pin
      t.timestamps
    end
  end
end
