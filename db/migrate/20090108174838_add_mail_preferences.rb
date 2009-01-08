class AddMailPreferences < ActiveRecord::Migration
  def self.up
    add_column :users, :mail_frequency, :integer, :null => false, :default => 0
    add_column :users, :include_replies, :boolean, :null => false, :default => false
  end

  def self.down
    remove_column :users, :mail_frequency
    remove_column :users, :include_replies
  end
end
