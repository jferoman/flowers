class CreateColdrooms < ActiveRecord::Migration[5.1]
  def change
    create_table :coldrooms do |t|
      t.string :name, null: false
      t.integer :capacity, null: false

      t.references :farm, null: false, index: true

      t.timestamps
    end
    add_index :coldrooms, [:name, :farm_id], unique: true
  end
end
