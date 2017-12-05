class CreateVarieties < ActiveRecord::Migration[5.1]
  def change
    create_table :varieties do |t|
      t.float :participation, null: false

      t.references :storage_resistance_type, null: false, index: true
      t.references :flower, null: false, index: true
      t.references :color, null: false, index: true

      t.timestamps
    end
  end
end
