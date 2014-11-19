namespace :import do
  desc "Papyrus Import Tasks"

  task :students => :environment do
    log "Importing Students from STDIN"

    STDIN.each_line do |line|
      puts line
    end
  end




    # Crude logging
  def log(string)
    if ENV['DEBUG'] != nil
      puts string
    end
  end

end
