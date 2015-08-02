class CreateParseTwurlsBatchAudits < ActiveRecord::Migration
  def change
    create_table :parse_twurls_batch_audits do |t|
      t.integer :twurls_created
      t.integer :twurls_errors
      t.integer :first_influencer_parsed_id
      t.integer :last_influencer_parsed_id

      t.timestamps
    end
  end
end
