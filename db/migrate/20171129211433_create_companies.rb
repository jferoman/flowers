class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :name, presence: true
      t.integer :nit, presence: true
      t.integer :phone

      t.timestamps
    end
  end
end
