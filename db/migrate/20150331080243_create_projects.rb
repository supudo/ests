class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title, null: false, index: true
      t.integer :client_id
      t.timestamps null: false
    end
  end
end
