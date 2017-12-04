class CreateCuttings < ActiveRecord::Migration[5.1]
  def change
    create_table :cuttings do |t|
      t.integer :quantity

      t.timestamps
    end
  end
end
