class ChangeVtScanFields < ActiveRecord::Migration
  def change
    add_column :transfers, :vt_malicious, :boolean
    add_column :transfers, :vt_status, :boolean
    add_column :transfers, :scan_malicious, :boolean
    add_column :transfers, :scan_status, :boolean
  end
end
