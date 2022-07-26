class PhaseCompletedJob < ApplicationJob
  queue_as :default

  def perform(phase_id)
    phase = Phase.find(phase_id)
    phase.save
  end
end
