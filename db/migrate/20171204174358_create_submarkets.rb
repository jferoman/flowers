class CreateSubmarkets < ActiveRecord::Migration[5.1]
  def change
    create_table :submarkets do |t|
      t.string :code, null: false, unique: true
      t.string :name, null: false

      t.references :market, index: true

      t.timestamps
    end
  end
end
