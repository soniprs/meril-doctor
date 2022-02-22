class CreateFamilyMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :family_members do |t|
      t.string :full_name
      t.string :gender
      t.string :relation
      t.date :date_of_birth
      t.decimal :weight
      t.string :blood_group
      t.references :patient, null: false, foreign_key: true
      t.timestamps
    end
  end
end
