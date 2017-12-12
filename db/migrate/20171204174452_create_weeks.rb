class CreateWeeks < ActiveRecord::Migration[5.1]
  def change
    create_table :weeks do |t|
      t.date :initial_day, null: false
      t.integer :week, null: false, index: true
      t.integer :model_week

      t.timestamps
    end
    add_index :weeks, [:initial_day, :week], unique: true

  end
end
