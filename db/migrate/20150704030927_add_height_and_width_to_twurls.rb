class AddHeightAndWidthToTwurls < ActiveRecord::Migration
  def change
    add_column :twurls, :headline_image_height, :integer
    add_column :twurls, :headline_image_width, :integer
  end
end
