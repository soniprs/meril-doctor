class CreatePrivacySettings < ActiveRecord::Migration[6.0]
  def change
    create_table :privacy_settings do |t|
      t.references :patient, :null => :true,:default => :null
      t.references :doctor, :null => :true, :default => :null
      t.string :language, default: "English"
      t.integer :mode , default: 0
      t.string :text_size
      t.timestamps
    end
  end
end
