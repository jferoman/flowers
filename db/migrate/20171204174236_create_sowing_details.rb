class CreateSowingDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :sowing_details do |t|
      t.integer :quantity

      t.references :variety, index: true
      t.references :week, index: true
      t.references :bed, index: true


      t.timestamps
    end
  end
end
