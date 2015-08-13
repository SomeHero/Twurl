class UserReadingList < ActiveRecord::Base
  belongs_to :user
  belongs_to :twurl_link

  def as_json(options={})
  {
    :id => self.id,
    :twurl => self.twurl_link,
  }
  end
end
