class UserMutedSource < ActiveRecord::Base
  belongs_to :user
  belongs_to :source

  def as_json(options={})
  {
    :source_id => self.source
  }
  end
end
