class CreateBedTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :bed_types do |t|
      t.string  :name,  presence: true
      t.integer :width, presence: true

      t.timestamps
    end
  end
end
