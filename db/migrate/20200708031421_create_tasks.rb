class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :text
      t.integer :user_id
      t.boolean :complete
    end
  end
end
