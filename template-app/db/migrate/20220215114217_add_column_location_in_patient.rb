class AddColumnLocationInPatient < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :location, :text
  end
end
