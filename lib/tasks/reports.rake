require 'csv'

namespace :reports do
  desc 'Papyrus: reports, item usage, USAGE: rake reports:item_usage [UNASSIGNED=false START_DATE=2009-01-31 END_DATE=2014-04-08] > item_usage.csv'
  task item_usage: :environment do
    start_date = ENV['START_DATE'] || Date.parse('2009-01-31')
    end_date = ENV['END_DATE'] || Date.today
    end_date = Date.parse(end_date) if end_date.is_a? String

    select_item_fields = 'items.title, items.id, items.callnumber, items.isbn, items.source'
    select_item_connections_fields = 'count(item_connections.student_id) as assigned_count, item_connections.created_at as assigned_at'
    select_fields = select_item_connections_fields + ', ' + select_item_fields
    where_clause = "where item_connections.created_at >= '#{start_date}' AND item_connections.created_at < '#{end_date + 1.day}'"

    sql = "SELECT #{select_fields} FROM item_connections INNER JOIN items ON item_connections.item_id = items.id #{where_clause} GROUP BY item_connections.item_id"

    @export_items = @assigned_items = ActiveRecord::Base.connection.exec_query(sql)

    if ENV['UNASSIGNED']
      @export_items = @unassigned_items = Item.where('id not in (?)', @assigned_items.collect do |i|
                                                                        i['id']
                                                                      end)
    end

    options = { force_quotes: true }

    csv_file = CSV.generate(options) do |csv|
      added_headers = false

      @export_items.each do |item|
        unless added_headers
          csv << %w[title callnumber source isbn assigned_count]
          added_headers = true
        end
        csv << [item['title'].to_s, item['callnumber'].to_s, item['source'].to_s, item['isbn'].to_s,
                item['assigned_count'].to_s]
      end
    end

    puts csv_file.to_s
    puts "\n\n\nTotal: #{@export_items.count}"
    puts "Date Range: #{start_date} to #{end_date}"
  end
end
