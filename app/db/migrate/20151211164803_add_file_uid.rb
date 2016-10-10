class AddFileUid < ActiveRecord::Migration
  def change
    add_column :transfers, :file_uid, :string
  end
end
