class CreateSowingDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :sowing_details do |t|
      t.integer :quantity

      t.timestamps
    end
  end
end
