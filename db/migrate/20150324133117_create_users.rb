class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.string :first_name
      t.string :last_name
      t.references :position, index: true, foreign_key: true
      t.references :technology, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
