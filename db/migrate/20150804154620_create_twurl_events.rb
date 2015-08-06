class CreateTwurlEvents < ActiveRecord::Migration
  def change
    create_table :twurl_events do |t|
      t.references :twurl_link, index: true
      t.string :twurl_event_name

      t.timestamps
    end
  end
end
