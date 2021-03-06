class CreateSowingDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :sowing_details do |t|
      t.integer :quantity, null: false
      t.integer :cutting_week, null: false
      t.string :origin, null: false

      t.references :variety, null: false, index: true
      t.references :bed, null: false, index: true
      t.references :week, null: false, index: true
      t.references :expiration_week, null: false, index: true

      t.timestamps
    end
    add_index :sowing_details, [:variety_id, :bed_id, :week_id], unique: true,  :name => 'sowing_detail'
  end
end
