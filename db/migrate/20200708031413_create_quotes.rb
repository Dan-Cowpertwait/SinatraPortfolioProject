class CreateQuotes < ActiveRecord::Migration
  def change
    create_table :quotes do |t|
      t.string :author
      t.string :text
      t.integer :user_id
    end
  end
end
