require 'csv'

desc "Import Sources"
task :import_sources=> [:environment] do

  file = "db/sources.csv"

  Influencer.destroy_all

  CSV.foreach(file, :headers => true) do |row|

    category = Category.where(:name => row[2]).first

    if(!category)
      category= Category.create!(
        name: row[2]
      )
    end

    channel = Channel.where(:name => row[3]).first

    if(!channel)
      channel = Channel.create!(
        :name => row[3],
        :category => category
      )
    end

    source = Influencer.create!(
      :twitter_username => row[0],
      :handle => row[1],
      :channel => channel
    )
  end

end