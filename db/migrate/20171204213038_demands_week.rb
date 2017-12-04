class DemandsWeek < ActiveRecord::Migration[5.1]
  def change
    create_table :demands_weeks do |t|

      t.references :demand, index: true
      t.references :week, index: true

      t.timestamps
    end
  end
end
