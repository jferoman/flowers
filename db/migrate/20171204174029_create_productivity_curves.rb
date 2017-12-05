class CreateProductivityCurves < ActiveRecord::Migration[5.1]
  def change
    create_table :productivity_curves do |t|
      t.integer :week_number
      t.float :cost
      t.integer :production
      t.integer :cut

      t.references :farm, index: true
      t.references :variety, index: true

      t.timestamps
    end
  end
end
