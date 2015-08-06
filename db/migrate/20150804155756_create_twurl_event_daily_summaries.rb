class CreateTwurlEventDailySummaries < ActiveRecord::Migration
  def change
    create_table :twurl_event_daily_summaries do |t|
      t.references :twurl_link, index: true
      t.string :twurl_event_name
      t.integer :count
      t.date :event_date

      t.timestamps
    end
  end
end
