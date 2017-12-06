class CreateFarms < ActiveRecord::Migration[5.1]
  def change
    create_table :farms do |t|
      t.string :code, null: false, unique: true
      t.float :mamsl
      t.float :pluviosity

      t.references :company, null: false, index: true

      t.timestamps
    end
  end
end
