class CreateProductions < ActiveRecord::Migration[5.1]
  def change
    create_table :productions do |t|
      t.integer :quantity, null: false
      t.string :status, null: false

      t.references :variety, null: false, index: true
      t.references :farm, null: false, index: true
      t.references :week, null: false, index: true

      t.timestamps
    end
    add_index :productions, [:variety_id, :farm_id, :week_id, :status], unique: true,  :name => 'production_status'

  end
end