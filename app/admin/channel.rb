ActiveAdmin.register Channel do
  controller do
    def scoped_collection
      super.includes :category
    end
  end
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
permit_params :name, :category_id

index do
  column :id
  column :category
  column :name
  column :created_at
  column :updated_at
  actions
end

end
