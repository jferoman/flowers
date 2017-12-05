class CreateMarkets < ActiveRecord::Migration[5.1]
  def change
    create_table :markets do |t|
      t.string :code, null: false, unique: true
      t.string :name, null: false, unique: true

      t.references :company, null: false, index: true

      t.timestamps
    end
  end
end
