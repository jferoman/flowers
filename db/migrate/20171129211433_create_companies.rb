class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :name, null: false
      t.integer :nit, null: false
      t.int :phone

      t.timestamps
    end
  end
end
