class AddDisplayToTwurls < ActiveRecord::Migration
  def change
    add_column :twurls, :display, :boolean, :default => true
    add_index :twurls, :display
  end
end
