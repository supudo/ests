class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, null: false, index: true, unique: true
      t.string :password, null: false
      t.string :first_name, null: false
      t.string :last_name
      t.string :remember_token
      t.integer :technology_id, null: false
      t.integer :position_id, null: false

      t.timestamps null: false
    end
  end
end
