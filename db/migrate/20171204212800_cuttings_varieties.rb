class CuttingsVarieties < ActiveRecord::Migration[5.1]
  def change
    create_table :cuttings_varieties do |t|

      t.references :cutting, index: true
      t.references :variety, index: true

      t.timestamps
    end
  end
end
