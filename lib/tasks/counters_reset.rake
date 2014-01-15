namespace :db do
  desc "Papyrus: reset cached counters columns"
 
  
  task :reset_cache_counters => :environment do 
    Item.find_each(select: :id) do |result|
      Item.reset_counters(result.id, :attachments)
    end
  end
    
end