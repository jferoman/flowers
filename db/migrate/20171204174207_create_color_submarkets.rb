class CreateColorSubmarkets < ActiveRecord::Migration[5.1]
  def change
    create_table :color_submarkets do |t|
      t.float :price, null: false
      t.boolean :default, null: false

      t.references :color, null: false, index: true
      t.references :submarket, null: false, index: true

      t.timestamps
    end

    add_index :color_submarkets, [:color_id,:submarket_id], unique: true
  end
end
