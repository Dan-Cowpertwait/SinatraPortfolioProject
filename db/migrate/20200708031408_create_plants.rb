class CreatePlants < ActiveRecord::Migration
  def change
    create_table :plants do |t|
      t.string :name
      t.integer :health
      t.integer :water_date
      t.boolean :alive
      t.integer :user_id
    end
  end
end
