class AddFullNameToSmsOtp < ActiveRecord::Migration[6.0]
  def change
    add_column :sms_otps, :full_name, :string
  end
end
