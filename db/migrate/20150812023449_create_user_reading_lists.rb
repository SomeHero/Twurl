class CreateUserReadingLists < ActiveRecord::Migration
  def change
    create_table :user_reading_lists do |t|
      t.references :user, index: true
      t.references :twurl_link, index: true

      t.timestamps
    end
  end
end
