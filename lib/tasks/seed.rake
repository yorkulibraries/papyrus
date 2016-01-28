namespace :db do
  namespace :seed do
    task :file => :environment do
      filename = Dir["#{ENV['FILE']}"][0]
      if File.exist?(filename)
        puts "Seeding #{filename}..."
        #load(filename) if File.exist?(filename)
      else
        puts "#{filename} not found"
      end
    end
  end
end
