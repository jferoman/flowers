class CreateBedTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :bed_types do |t|
      t.string  :name, null: false, unique: true
      t.integer :width, null: false

      t.timestamps
    end
    add_index :bed_types, [:name, :width], unique: true

  end
end
