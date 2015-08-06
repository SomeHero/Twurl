class CreateInfluencerEventDailySummaries < ActiveRecord::Migration
  def change
    create_table :influencer_event_daily_summaries do |t|
      t.references :influencer, index: true
      t.string :influencer_event_name
      t.integer :count
      t.date :event_date

      t.timestamps
    end
  end
end
