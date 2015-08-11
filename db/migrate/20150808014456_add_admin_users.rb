class AddAdminUsers < ActiveRecord::Migration
  def change
    AdminUser.create!({:email => 'admin@twurl.net', :password => 'twurl424#'  })
  end
end
