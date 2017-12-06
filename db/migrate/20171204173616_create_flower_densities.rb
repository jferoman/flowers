class CreateFlowerDensities < ActiveRecord::Migration[5.1]
  def change
    create_table :flower_densities do |t|
      t.float :density, null: false

      t.references :farm, null: false, index: true
      t.references :flower, null: false, index: true

      t.timestamps
    end
    add_index :flower_densities, [:farm_id, :flower_id], unique: true

  end
end
