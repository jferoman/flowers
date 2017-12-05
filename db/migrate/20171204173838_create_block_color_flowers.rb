class CreateBlockColorFlowers < ActiveRecord::Migration[5.1]
  def change
    create_table :block_color_flowers do |t|
      t.boolean :usage

      t.references :block, index: true
      t.references :flower, index: true
      t.references :color, index: true

      t.timestamps
    end
  end
end
