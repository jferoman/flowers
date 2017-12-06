class CreateColdrooms < ActiveRecord::Migration[5.1]
  def change
    create_table :coldrooms do |t|
      t.string :name, null: false
      t.integer :capacity, null: false

      t.references :farm, null: false, index: true

      t.timestamps
    end
  end
end
