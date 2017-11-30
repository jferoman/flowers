class CreateBeds < ActiveRecord::Migration[5.1]
  def change
    create_table :beds do |t|
      t.string :number, presence: true, index: true
      t.float :area, presence: true
      t.string :type, presence: true
      t.integer :capacity, presence: true

      t.references :block, index: true

      t.timestamps
    end
  end
end
