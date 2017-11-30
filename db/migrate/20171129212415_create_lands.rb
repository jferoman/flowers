class CreateLands < ActiveRecord::Migration[5.1]
  def change
    create_table :lands do |t|
      t.string :code, presence: true
      t.float :total_area, presence: true
      t.float :altitude
      t.float :pluviosity

      t.references :company, index: true

      t.timestamps
    end
  end
end
