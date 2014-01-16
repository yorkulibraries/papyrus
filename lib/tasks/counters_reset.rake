namespace :db do
  desc "Papyrus: reset cached counters columns"
 
  
  task :reset_cache_counters => :environment do 
    Item.find_each(select: :id) do |item|
      count = item.attachments.available.size
      item.connection.execute("update items set attachments_count=#{count} where id = #{item.id}")
    end
  end
    
end