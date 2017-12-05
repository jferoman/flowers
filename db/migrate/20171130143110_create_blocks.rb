class CreateBlocks < ActiveRecord::Migration[5.1]
  def change
    create_table :blocks do |t|
      t.string :name, null: false

      t.references :farm, null: false, index: true

      t.timestamps
    end
    add_index :blocks, [:name, :farm_id], unique: true

  end
end
