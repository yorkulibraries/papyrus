namespace :db do
  desc "Papyrus: reset cached counters columns"
 
  
  task :reset_cache_counters => :environment do 
    Item.find_each(select: :id) do |item|
      count = item.attachments.available.count
      item.connection.execute("update items set attachments_count=#{count} where id = #{item.id}")
    end
    
    Term.find_each(select: :id) do |term|
      Term.reset_counters(term.id, :courses)
    end
    
    Course.find_each(select: :id) do |course|
      count = course.items.count
      course.connection.execute("update courses set items_count=#{count} where id = #{course.id}")
    end
  end
    
end