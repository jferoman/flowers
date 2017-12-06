class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :name, null: false, unique: true
      t.integer :nit, null: false, unique: true
      t.string :phone

      t.timestamps
    end
  end
end
