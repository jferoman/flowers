class CreateSubmarketWeeks < ActiveRecord::Migration[5.1]
  def change
    create_table :submarket_weeks do |t|

      t.timestamps
    end
  end
end
