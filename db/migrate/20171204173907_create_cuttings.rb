class CreateCuttings < ActiveRecord::Migration[5.1]
  def change
    create_table :cuttings do |t|
      t.integer :quantity, null: false
      t.integer :cutting_week, null: false
      t.string :origin, null: false

      t.references :farm, null: false, index: true
      t.references :week, null: false, index: true
      t.references :variety, null: false, index: true

      t.timestamps
    end
  end
end
