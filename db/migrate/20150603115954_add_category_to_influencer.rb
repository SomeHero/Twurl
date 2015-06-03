class AddCategoryToInfluencer < ActiveRecord::Migration
  def change
    add_column :influencers, :category_id, :integer
  end
end
