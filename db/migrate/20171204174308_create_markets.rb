class CreateMarkets < ActiveRecord::Migration[5.1]
  def change
    create_table :markets do |t|
      t.string :code
      t.string :country

      t.timestamps
    end
  end
end
