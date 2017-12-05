class CreateStorageResistances < ActiveRecord::Migration[5.1]
  def change
    create_table :storage_resistances do |t|
      t.integer :week_number
      t.float :lost_percentage

      t.references :storage_resistance_type, index: true

      t.timestamps
    end
  end
end
