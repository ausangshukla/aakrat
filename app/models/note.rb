class Note < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :company
  belongs_to :owner, polymorphic: true, optional: true
  has_rich_text :details

  has_many_attached :attachments, service: :amazon, dependent: :destroy
end
