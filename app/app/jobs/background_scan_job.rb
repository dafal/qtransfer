class BackgroundScanJob < ActiveJob::Base
  queue_as :default

  def perform(*argv)
    transfer = self.arguments.first
    transfer.security_checks
    transfer.scan_background = false
    transfer.save
  end
end
