class TransfersController < ApplicationController
  before_filter :first_time_visiting?,:session_set?,:set_gon_var
  
  # Default method (startpage)
  def new_multiple   
    @transfer = Transfer.new
    @transfers = Transfer.where(:session_id => session[:session_id]).order(created_at: :desc).limit(5).reverse
  end
  
  # Method for the creation of a +Transfer+ object
  def create
    respond_to do |format|
      begin
        # Creation of the +Transfer+ object
        @transfer = Transfer.new(transfer_params)
        @transfer.session_id = session[:session_id]
        @transfer.file_size = @transfer.file.size
        @transfer.file_name = @transfer.file.name
        @transfer.token = Digest::CRC64.hexdigest(SecureRandom.uuid)
        
        # Security checks
        if @transfer.file.size > eval(Rails.configuration.x.app_config['synchronous_clamav_scan_limit_size'])
          @transfer.scan_background = true
          @transfer.save
          BackgroundScanJob.perform_later @transfer
        else
          @transfer.security_checks
        end
        @transfer.save  
      rescue => e
        @error = e.message
      end 
      format.js  { render :partial => "append_message", :locals => {:transfer => @transfer} } 
      format.html { redirect_to new_transfer_path }
    end
  end
  
  # Method to download the file
  def get_file
    sleep 1
    @transfer = Transfer.find_by_token(params[:token]) or file_not_found
    response.headers['Content-Length'] = @transfer.file.size.to_s
    send_file @transfer.file.path, :filename => @transfer.file.name
  end
  
  # Method to update messages for the last 5 transfers
  def messages_update
      @transfers = Transfer.find(:session_id => session[:session_id]).order(created_at: :desc).limit(5).reverse
      respond_to do |format|
          format.js  { render :partial => "messages", :locals => {:transfers => @transfers} }
      end
  end
  
  # Method to update messages for the last 5 transfers
  def update_message
      
      @transfer = Transfer.find(params[:id])
      respond_to do |format|
          format.js  { render :partial => "update_message", :locals => {:transfer => @transfer} }
      end
  end

  private
    def transfer_params
      params.require(:transfer).permit(:file)
    end
    
end
