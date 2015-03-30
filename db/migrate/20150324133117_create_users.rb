class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :first_name
      t.string :last_name
      t.string :remember_token
      t.integer :technology_id
      t.integer :position_id

      t.timestamps null: false
    end
  end
end
