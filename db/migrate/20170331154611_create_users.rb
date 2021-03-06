class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.boolean :admin, default: false
      t.integer :default_farm, null: false

      t.references :company, index: true

      t.timestamps
    end
  end
end
