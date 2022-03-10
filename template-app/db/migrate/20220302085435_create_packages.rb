class CreatePackages < ActiveRecord::Migration[6.0]
  def change
    create_table :packages do |t|
      t.string :name
      t.integer :no_of_tests
      t.integer :consultation_fees
      t.text :description
      t.integer :sample_requirement
      t.string :duration
      t.integer :doctor_id
      t.timestamps
    end
  end
end
