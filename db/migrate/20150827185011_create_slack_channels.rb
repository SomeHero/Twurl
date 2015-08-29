class CreateSlackChannels < ActiveRecord::Migration
  def change
    create_table :slack_channels do |t|
      t.references :slack_team, index: true
      t.string :channel_name
      t.string :webhook_url

      t.timestamps
    end
  end
end
