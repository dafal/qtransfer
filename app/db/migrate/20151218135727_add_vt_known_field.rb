class AddVtKnownField < ActiveRecord::Migration
  def change
    add_column :transfers, :vt_known, :boolean, :default => false
  end
end
