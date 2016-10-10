class Transfer < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  dragonfly_accessor :file
  validates :file, presence: true
  validates_size_of :file, maximum: eval(Rails.configuration.x.app_config['maximum_file_size'])
  
  # ClamAV scan method, returns true if virus found
  def clamav_scan
    self.scan_started_at = Time.now
    begin
      io = File.open(self.file.file)
      client = ClamAV::Client.new
      client.execute(ClamAV::Commands::PingCommand.new)
      response = client.execute(ClamAV::Commands::InstreamCommand.new(io))
      self.scan_finished_at = Time.now
      case response
      when ClamAV::SuccessResponse
        self.scan_status = true
        self.scan_malicious = false
        self.scan_result = "ok"
      when ClamAV::VirusResponse
        self.scan_status = true
        self.scan_malicious = true
        self.scan_result = response.virus_name
        Rails.logger.warn "Scanning #{self.file_name} (ID : #{self.id}) : virus found (#{self.scan_result})"
      when ClamAV::ErrorResponse
        self.scan_status = false
        self.scan_error = response.error_str
      end
    rescue => e
      Rails.logger.error "Error scanning for file #{self.file_name} (ID : #{self.id}) : #{e.message}"
      self.scan_error = e.message
      self.scan_status = false
    end
    self.malicious
  end
  
  # VirusTotal hash check, returns true if at least 1 AV detects the file as malicious
  def vt_check
    begin
      hash = Digest::SHA2.file(self.file.path).hexdigest
      results = Uirusu::VTFile.query_report(Rails.configuration.x.app_config['vt_api_key'],hash)
      self.vt_result = Uirusu::VTResult.new(hash, results).to_stdout
      self.vt_checked = true
      self.vt_status = true
      self.vt_detections = 0
      if not results['scans'] == nil
        results['scans'].each do |scanner,value|
          if value != ''
            unless value['result'] == nil
              self.vt_malicious = true
              self.vt_detections += 1
            end
          end
        end
        
        if self.vt_detections == 0
          self.vt_malicious = false  
        else
          Rails.logger.warn "VT check #{self.file_name} (ID : #{self.id}) : known as malicious by #{self.vt_detections} engine(s), see vt_result field for details"
        end               
      end
    rescue => e
      Rails.logger.error "Error virustotal check for file #{self.file_name} (ID : #{self.id}) : #{e.message}"
      self.vt_error = e.message
      self.vt_status = false
    end
  end
  
  # Perform security checks
  def security_checks
    if Rails.configuration.x.app_config['vt_check']
      self.vt_check
    end
    if self.vt_malicious.nil?
      self.clamav_scan
    end
  end
end
