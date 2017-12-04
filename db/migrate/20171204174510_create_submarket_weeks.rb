class CreateSubmarketWeeks < ActiveRecord::Migration[5.1]
  def change
    create_table :submarket_weeks do |t|

      t.references :week, index: true
      t.references :submarket, index: true

      t.timestamps
    end
  end
end
