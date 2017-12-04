class CreateColorSubmarkets < ActiveRecord::Migration[5.1]
  def change
    create_table :color_submarkets do |t|
      t.float :price
      t.boolean :default

      t.references :color, index: true
      t.references :submarket, index: true

      t.timestamps
    end
  end
end
