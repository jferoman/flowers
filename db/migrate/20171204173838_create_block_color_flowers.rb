class CreateBlockColorFlowers < ActiveRecord::Migration[5.1]
  def change
    create_table :block_color_flowers do |t|
      t.boolean :usage, null: false

      t.references :block, null: false, index: true
      t.references :flower, null: false, index: true
      t.references :color, null: false, index: true

      t.timestamps
    end
    add_index :block_color_flowers, [:block_id, :flower_id, :color_id], unique: true,  :name => 'block_color_flower'

  end
end
