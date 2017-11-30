class CreateFlowers < ActiveRecord::Migration[5.1]
  def change
    create_table :flowers do |t|
      t.string :type, presence: true

      t.timestamps
    end
  end
end
