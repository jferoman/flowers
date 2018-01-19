class CreateSowingSolutions < ActiveRecord::Migration[5.1]
  def change
    create_table :sowing_solutions do |t|
      t.integer :quantity, null: false
      t.integer :cutting_week, null: false

      t.references :variety, null: false, index: true
      t.references :week, null: false, index: true
      t.references :block, null: false, index: true
      t.references :bed_type, null: false, index: true
      t.references :expiration_week, null: false, index: true

      t.timestamps
    end
    add_index :sowing_solutions, [:variety_id, :block_id, :week_id, :bed_type_id, :cutting_week], unique: true,  :name => 'sowing_solution'

  end
end
