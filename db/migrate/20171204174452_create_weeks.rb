class CreateWeeks < ActiveRecord::Migration[5.1]
  def change
    create_table :weeks do |t|
      t.date :initial_day
      t.integer :week

      t.timestamps
    end
  end
end
