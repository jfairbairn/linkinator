class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :user_id, :null => false
      t.string :title, :null => false
      t.string :url
      t.text :content
      t.timestamps
    end
    
    add_index :posts, :user_id
  end

  def self.down
    drop_table :posts
  end
end
