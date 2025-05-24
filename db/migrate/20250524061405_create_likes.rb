class CreateLikes < ActiveRecord::Migration[7.1]
  def change
    create_table :likes do |t|
      t.integer :photo_id
      t.integer :fan_id

      t.timestamps
    end
    add_index :likes, :photo_id
    add_index :likes, :fan_id
  end
end
