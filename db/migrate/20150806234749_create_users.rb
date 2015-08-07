class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :twitter_id
      t.string :twitter_username
      t.string :twitter_auth_token
      t.string :twitter_secret
      t.string :first_name
      t.string :last_name
      t.string :email_address

      t.timestamps
    end
  end
end
