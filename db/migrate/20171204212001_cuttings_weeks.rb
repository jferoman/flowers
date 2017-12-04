class CuttingsWeeks < ActiveRecord::Migration[5.1]
  def change
    create_table :cuttings_weeks do |t|

      t.references :cutting, index: true
      t.references :week, index: true

      t.timestamps
    end
  end
end
