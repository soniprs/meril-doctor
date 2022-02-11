class AddFullNameToEmailOtp < ActiveRecord::Migration[6.0]
  def change
    add_column :email_otps, :full_name, :string
  end
end
