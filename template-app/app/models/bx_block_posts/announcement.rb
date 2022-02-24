module BxBlockPosts
  class Announcement < ApplicationRecord
    self.table_name = :announcements
    include ActiveStorageSupport::SupportForBase64
    belongs_to :doctor, class_name: 'AccountBlock::Doctor'
    has_one_base64_attached :avatar
    validates :title, presence: true
  end
end