class CreateTechnologies < ActiveRecord::Migration
  def change
    create_table :technologies do |t|
      t.string :title

      t.timestamps null: false
    end
  end
end
