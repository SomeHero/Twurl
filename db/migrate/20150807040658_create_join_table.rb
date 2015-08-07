class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :feeds, :twurls do |t|
      # t.index [:feed_id, :twurl_id]
      # t.index [:twurl_id, :feed_id]
    end
  end
end
