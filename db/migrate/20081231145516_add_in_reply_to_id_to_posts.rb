class AddInReplyToIdToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :in_reply_to_id, :integer
    add_index :posts, :in_reply_to_id
  end

  def self.down
    remove_column :posts, :in_reply_to_id
  end
end
