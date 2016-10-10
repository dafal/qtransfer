class AddVtFields < ActiveRecord::Migration
  def change
    add_column :transfers, :vt_check, :boolean, :default => false
    add_column :transfers, :vt_result, :string
  end
end
