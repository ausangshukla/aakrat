# == Schema Information
#
# Table name: payments
#
#  id               :integer          not null, primary key
#  company_id        :integer          not null
#  amount           :decimal(10, 2)   default("0.00"), not null
#  plan             :string(30)
#  discount         :decimal(10, 2)   default("0.00")
#  reference_number :string(255)
#  user_id          :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  deleted_at       :datetime
#

require "test_helper"

class PaymentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
