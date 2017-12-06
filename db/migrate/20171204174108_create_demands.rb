class CreateDemands < ActiveRecord::Migration[5.1]
  def change
    create_table :demands do |t|
      t.integer :quantity, null: false

      t.references :color, null: false, index: true
      t.references :flower, null: false, index: true
      t.references :market, null: false, index: true
      t.references :week, null: false, index: true

      t.timestamps
    end
    add_index :demands, [:color_id, :flower_id, :market_id, :week_id], unique: true,  :name => 'demand_color_flower_market'

  end
end
