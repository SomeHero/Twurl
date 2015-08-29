class SlackChannel < ActiveRecord::Base
  belongs_to :slack_team

  def as_json(options={})
  {
    :id => self.id,
    :channel_name => self.channel_name
  }
  end

end
