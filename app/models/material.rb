class Material < ApplicationRecord
  belongs_to :company
  belongs_to :project
  belongs_to :owner, polymorphic: true, optional: true
  has_many_attached :attachments, service: :amazon, dependent: :destroy

  monetize :cost_cents, :unit_cost_cents, with_currency: ->(i) { i.project.currency }
end
