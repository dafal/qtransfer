#
# config/initializers/scheduler.rb

require 'rufus-scheduler'

# Let's use the rufus-scheduler singleton
#
s = Rufus::Scheduler.singleton


# Stupid recurrent task...
#
s.every Rails.configuration.x.app_config['cron'] do
  transfers = Transfer.where('created_at < ?',eval(Rails.configuration.x.app_config['cleanup']))
  transfers.each { |transfer|
    transfer_id = transfer.id
    transfer_file_name = transfer.file.name
    begin
      transfer.destroy
      Rails.logger.info "Transfer #{transfer_id} (#{transfer_file_name}) deleted"
      Rails.logger.flush
    rescue
      Rails.logger.error "Error deleting #{transfer_id} (#{transfer_file_name}) deleted"
    end
  }
end