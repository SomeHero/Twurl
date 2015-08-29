class User < ActiveRecord::Base
  has_many :feeds
  has_many :muted_sources, class_name: "UserMutedSource"
  has_many :reading_list_items, class_name: "UserReadingList"
  has_many :slack_teams

  def as_json(options={})
  {
    :id => self.id,
    :twitter_id => self.twitter_id,
    :twitter_username => self.twitter_username,
    :first_name => self.first_name,
    :last_name => self.last_name,
    :email_address => self.email_address,
    :muted_sources => self.muted_sources,
    :reading_list => self.reading_list_items,
    :slack_teams => self.slack_teams
  }
  end

end
