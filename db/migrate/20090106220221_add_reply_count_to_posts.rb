class AddReplyCountToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :reply_count, :integer, :null => false, :default => 0
  end

  def self.down
    remove_column :posts, :reply_count
  end
end
