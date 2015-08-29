class CreateSlackTeams < ActiveRecord::Migration
  def change
    create_table :slack_teams do |t|
      t.references :user, index: true
      t.string :team_name

      t.timestamps
    end
  end
end
