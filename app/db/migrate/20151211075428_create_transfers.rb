class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.string :name
      t.string :token
      t.datetime :upload_date

      t.timestamps null: false
    end
  end
end
