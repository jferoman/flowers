class CreateBeds < ActiveRecord::Migration[5.1]
  def change
    create_table :beds do |t|
      t.string :number, null: false, index: true
      t.float :total_area, null: false
      t.float :usable_area, null: false

      t.references :block, null: false, index: true
      t.references :bed_type, null: false, index: true

      t.timestamps
    end
    add_index :beds, [:number, :block_id], unique: true

  end
end
