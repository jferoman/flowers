class CreateSubmarkets < ActiveRecord::Migration[5.1]
  def change
    create_table :submarkets do |t|
      t.string :code
      t.string :name

      t.references :market, index: true

      t.timestamps
    end
  end
end
