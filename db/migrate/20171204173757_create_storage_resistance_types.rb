class CreateStorageResistanceTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :storage_resistance_types do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
