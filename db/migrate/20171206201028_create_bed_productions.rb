class CreateBedProductions < ActiveRecord::Migration[5.1]
  def change
    create_table :bed_productions do |t|
      t.integer :quantity, null: false
      t.string :origin, null: false

      t.references :variety, null: false, index: true
      t.references :bed, null: false, index: true
      t.references :week, null: false, index: true

      t.timestamps
    end
    add_index :bed_productions, [:variety_id, :bed_id, :week_id, :origin], unique: true,  :name => 'bed_production_origin'
  end
end
