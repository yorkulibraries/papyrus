namespace :db do
  desc "Papyrus: reset cached counters columns"
 
  
  task :reset_cache_counters => :environment do 
    Item.find_each(select: :id) do |item|
      item.update_attribute(:attachments_count, item.attachments.available.size)
    end
  end
    
end