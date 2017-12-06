class CreateProductivityCurves < ActiveRecord::Migration[5.1]
  def change
    create_table :productivity_curves do |t|
      t.integer :week_number, null: false
      t.float :cost, null: false
      t.integer :production, null: false
      t.integer :cut, null: false

      t.references :farm, null: false, index: true
      t.references :variety, null: false, index: true

      t.timestamps
    end
    add_index :productivity_curves, [:week_number, :farm_id, :variety_id], unique: true, :name => 'productivity_curve'
  end
end
