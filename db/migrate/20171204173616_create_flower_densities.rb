class CreateFlowerDensities < ActiveRecord::Migration[5.1]
  def change
    create_table :flower_densities do |t|
      t.float :density

      t.references :farm, index: true
      t.references :flower, index: true

      t.timestamps
    end
  end
end
