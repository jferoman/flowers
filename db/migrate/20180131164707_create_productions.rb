class CreateProductions < ActiveRecord::Migration[5.1]
  def change
    create_table :productions do |t|
      t.integer :quantity, null: false
      t.string :origin, null: false

      t.references :variety, null: false, index: true
      t.references :week, null: false, index: true
      t.references :cutting, null: false, index: true


      t.timestamps
    end
    add_index :productions, [:variety_id, :cutting_id, :week_id, :origin], unique: true,  :name => 'cut_production'
  end
end
