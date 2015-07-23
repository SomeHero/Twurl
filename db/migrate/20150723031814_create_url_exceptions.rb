class CreateUrlExceptions < ActiveRecord::Migration
  def change
    create_table :url_exceptions do |t|
      t.string :url

      t.timestamps
    end
  end
end
