class CreateDemands < ActiveRecord::Migration[5.1]
  def change
    create_table :demands do |t|
      t.integer :quantity

      t.references :company, index: true
      t.references :color, index: true
      t.references :flower, index: true
      t.references :market, index: true
      t.references :week, index: true


      t.timestamps
    end
  end
end
