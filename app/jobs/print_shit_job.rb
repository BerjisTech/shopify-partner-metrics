class PrintShitJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    # Repeat job
    # PrintShitJob.set(wait: 5.seconds).perform_later()
  end
end
