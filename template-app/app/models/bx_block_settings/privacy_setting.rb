module BxBlockSettings
  class PrivacySetting < ApplicationRecord
    self.table_name = :privacy_settings
    enum mode: %i[light_mode dark_mode]
  end
end
