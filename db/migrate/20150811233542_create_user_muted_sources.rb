class CreateUserMutedSources < ActiveRecord::Migration
  def change
    create_table :user_muted_sources do |t|
      t.references :user, index: true
      t.references :source, index: true

      t.timestamps
    end
  end
end
