class CreateStorageResistances < ActiveRecord::Migration[5.1]
  def change
    create_table :storage_resistances do |t|
      t.integer :week_number, null: false
      t.float :lost_percentage, null: false

      t.references :storage_resistance_type, null: false, index: true

      t.timestamps
    end
  end
end
