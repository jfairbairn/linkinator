class CreateUrls < ActiveRecord::Migration
  def self.up
    create_table :posts_urls, :id => false do |t|
      t.integer :post_id, :null => false
      t.integer :url_id, :null => false
    end
    
    add_index :posts_urls, [:post_id, :url_id], :unique => true
    
    create_table :urls do |t|
      t.string :url, :null => false
      t.timestamps
    end
    
    add_index :urls, :url, :unique => true
    
    Post.reset_column_information
    
    Post.find(:all).each do |p|
      p.save
    end
    
    remove_column :posts, :url
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
