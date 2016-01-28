namespace :db do
  namespace :seed do
    task :file => :environment do
      filename = Dir[File.join(Rails.root, 'db', 'seeds', "#{ENV['FILE']}.seeds.rb")][0]
      puts "Seeding #{filename}..."
      load(filename) if File.exist?(filename)
    end
  end
end
