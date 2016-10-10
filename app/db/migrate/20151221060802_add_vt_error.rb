class AddVtError < ActiveRecord::Migration
  def change
    add_column :transfers, :vt_error, :string
  end
end
