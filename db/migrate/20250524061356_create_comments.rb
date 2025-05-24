class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.text :body
      t.integer :photo_id
      t.integer :author_id

      t.timestamps
    end
    add_index :comments, :photo_id
    add_index :comments, :author_id
  end
end
