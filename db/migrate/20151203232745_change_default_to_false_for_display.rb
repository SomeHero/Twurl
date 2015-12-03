class ChangeDefaultToFalseForDisplay < ActiveRecord::Migration
  def change
    change_column :twurls, :display, :boolean, :default => false
  end
end
