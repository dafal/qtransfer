class AddFileMetadata < ActiveRecord::Migration
  def change
    add_column :transfers, :file_size, :integer
    add_column :transfers, :file_name, :string
  end
end
