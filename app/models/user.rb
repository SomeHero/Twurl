class User < ActiveRecord::Base
  has_many :feeds

  def as_json(options={})
  {
    :id => self.id,
    :twitter_id => self.twitter_id,
    :twitter_username => self.twitter_username,
    :first_name => self.first_name,
    :last_name => self.last_name,
    :email_address => self.email_address
  }
  end

end
