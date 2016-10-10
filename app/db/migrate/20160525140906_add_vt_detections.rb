class AddVtDetections < ActiveRecord::Migration
  def change
    add_column :transfers, :vt_detections, :integer
  end
end
