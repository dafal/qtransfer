class RenameVtField < ActiveRecord::Migration
  def change
    remove_column :transfers, :vt_check, :boolean, :default => false
    add_column :transfers, :vt_checked, :boolean, :default => false
  end
end
