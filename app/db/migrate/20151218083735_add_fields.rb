class AddFields < ActiveRecord::Migration
  def change
    add_column :transfers, :scanned, :boolean, :default => false
    add_column :transfers, :scan_started_at, :datetime
    add_column :transfers, :scan_finished_at, :datetime
    add_column :transfers, :session_id, :string
  end
end
