class CreateAnnouncements < ActiveRecord::Migration[6.0]
  def change
    create_table :announcements do |t|
      t.string :title
      t.text :description
      t.text :tags
      t.string :status
      t.binary :image
      t.integer :doctor_id
      t.timestamps
    end
  end
end
