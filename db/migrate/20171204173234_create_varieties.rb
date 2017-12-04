class CreateVarieties < ActiveRecord::Migration[5.1]
  def change
    create_table :varieties do |t|
      t.float :participation

      t.references :storage_resistance_type, index: true
      t.references :flower, index: true
      t.references :color, index: true

      t.timestamps
    end
  end
end
