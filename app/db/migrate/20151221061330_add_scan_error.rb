class AddScanError < ActiveRecord::Migration
  def change
    add_column :transfers, :scan_error, :string
  end
end
