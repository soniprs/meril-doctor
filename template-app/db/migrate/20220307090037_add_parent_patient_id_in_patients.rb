class AddParentPatientIdInPatients < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :parent_patient_id, :integer,foreign_key: true
  end
end
