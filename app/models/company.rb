# == Schema Information
#
# Table name: companies
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  url                    :string(255)
#  category               :string(255)
#  founded                :date
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  logo_url               :text(65535)
#  active                 :boolean          default("1")
#  company_type            :string(15)
#  created_by             :integer
#  investor_categories    :string(255)
#  instrument_types       :string(255)
#  s3_bucket              :string(255)
#  deleted_at             :datetime
#  investors_count        :integer          default("0"), not null
#  investments_count      :integer          default("0"), not null
#  deals_count            :integer          default("0"), not null
#  deal_investors_count   :integer          default("0"), not null
#  documents_count        :integer          default("0"), not null
#  total_investments      :decimal(20, )    default("0")
#  is_holdings_company     :boolean          default("0")
#  enable_documents       :boolean          default("0")
#  enable_deals           :boolean          default("0")
#  enable_investments     :boolean          default("0")
#  enable_holdings        :boolean          default("0")
#  enable_secondary_sale  :boolean          default("0")
#  parent_company_id       :integer
#  currency               :string(10)
#  units                  :string(15)
#  trial_end_date         :date
#  trial                  :boolean          default("0")
#  tasks_count            :integer
#  pending_accesses_count :integer
#  active_deal_id         :integer
#  equity                 :integer          default("0")
#  preferred              :integer          default("0")
#  options                :integer          default("0")
#

class Company < ApplicationRecord
  include Trackable

  validates :name, uniqueness: true
  # Make all models searchable
  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  validates :name, :company_type, presence: true

  has_rich_text :details

  # Will have many employees
  has_many :users, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :clients, dependent: :destroy
  has_many :attachments, dependent: :destroy

  has_one_attached :logo, service: :amazon, dependent: :destroy

  TYPES = ["Architect"].freeze

  before_save :check_url
  def check_url
    self.url = "http://#{url}" if url.present? && !(url.starts_with?("http") || url.starts_with?("https"))
    self.logo_url = "http://#{logo_url}" if logo_url.present? && !(logo_url.starts_with?("http") || logo_url.starts_with?("https"))
  end

  def to_s
    name
  end
end
