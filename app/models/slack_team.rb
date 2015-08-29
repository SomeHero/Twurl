class SlackTeam < ActiveRecord::Base
  belongs_to :user
  has_many :slack_channels

  def as_json(options={})
  {
    :team_name => self.team_name,
    :channels => self.slack_channels
  }
  end
end
