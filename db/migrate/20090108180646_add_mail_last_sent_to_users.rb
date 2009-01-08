class AddMailLastSentToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :last_mail, :datetime, :null => false, :default => 0
  end

  def self.down
    remove_column :users, :last_mail
  end
end
