# new migration XXX_add_active_to_users.rb
class AddActiveToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :active, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :users, :active
  end
end
