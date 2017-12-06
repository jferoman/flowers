class CreateModelSowingSolutions < ActiveRecord::Migration[5.1]
  def change
    create_table :model_sowing_solutions do |t|
      t.integer :bed_number, null: false

      t.references :block, null: false, index: true
      t.references :bed_type, null: false, index: true

      t.timestamps
    end
  end
end
