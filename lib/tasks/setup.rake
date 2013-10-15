namespace :app do
  
  desc "Copy template config files."  
  task :setup do
    puts "\n====================================================="
    puts "  Setting up default configration files " 
    puts "=====================================================\n\n"
    
    Dir.glob("#{Rails.root}/config/*.default.yml").each do |file|
      template_file = File.basename(file)
       file = File.basename(template_file, '.default.yml') # cut out default.yml
       file = file << '.yml'
      if File.exists?(Rails.root.join('config', file))
        input = ''
        puts "#{file} already exists."
        STDOUT.puts "Do you wish to override? [Y/n]"
        input = STDIN.gets.chomp
        if input == "Y"
          puts "Overriding #{file}"
          cp Rails.root.join('config', template_file), Rails.root.join('config', file)
        else
          puts "Skipping: #{file}"
        end
      else
        puts "Creating: #{file}"
        cp Rails.root.join('config', template_file), Rails.root.join('config', file)
      end
    end
    
    puts "\n====================================================="
    puts "  Follow the following steps to complete the installation."
    puts "======================================================\n\n"
    puts "1) Create Your Database & User\n"
    puts "2) Modify database.yml to match your database settings\n"
    puts "3) Run: rake db:migrate\n"
    puts "4) Modify papyrus_config.yml \n"    
    puts "5) Run: rake app:setup_admin_user\n"    
    puts "6) To test installation, Run: rails s"
    puts "7) Visit http://locahost:3000/login\n"
    puts "\n======================================================\n\n"
    exit 0
  end
    
  task :setup_admin_user => :environment do
    puts "\n====================================================="
    puts "  Setting up admin user" 
    puts "=====================================================\n\n"
    
    # admin user     
    admin = User.new
    STDOUT.puts "Admin Full Name?"
    admin.name = STDIN.gets.chomp
    STDOUT.puts "Admin Email?"
    admin.email = STDIN.gets.chomp
    STDOUT.puts "Admin Username?"
    admin.username = STDIN.gets.chomp
    admin.role = User::ADMIN
    admin.inactive = false
    admin.save
    
    puts "\n====================================================="
    puts "  Finished setting up admin user." 
    puts "=====================================================\n\n"
  end
end
