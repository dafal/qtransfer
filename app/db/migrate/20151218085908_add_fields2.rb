class AddFields2 < ActiveRecord::Migration
  def change
    add_column :transfers, :malicious, :boolean
    add_column :transfers, :scan_result, :string
  end
end
