class CreateBlocks < ActiveRecord::Migration[5.1]
  def change
    create_table :blocks do |t|
      t.string :name, presence: true
      t.float :area, presence: true

      t.references :land, index: true

      t.timestamps
    end
  end
end
