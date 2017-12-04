class CreateBeds < ActiveRecord::Migration[5.1]
  def change
    create_table :beds do |t|
      t.string :number, presence: true, index: true
      t.float :total_area, presence: true
      t.float :usable_area, presence: true

      t.references :block, index: true
      t.references :bed_type, index: true

      t.timestamps
    end
  end
end
