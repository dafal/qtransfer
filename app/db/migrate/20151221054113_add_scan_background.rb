class AddScanBackground < ActiveRecord::Migration
  def change
    add_column :transfers, :scan_background, :boolean
  end
end
