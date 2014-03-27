class StatsController < ApplicationController
  before_filter :authorize_check

  def index
    @has_attachments_count = Attachment.count("item_id", distinct: true)
    @has_students_count = ItemConnection.count("item_id", distinct: true)
    
  end

  def generate
    if params[:assigned_to]
      id = params[:assigned_to]
      assigned_to = User.find(id)
      @title = "Students Assgined to #{assigned_to.name}"
      @results = Student.includes(:student_details).joins(:student_details).where("transcription_coordinator_id = ? or transcription_assistant_id = ?", id, id)
    else
      @results = Array.new
    end
    
    respond_to do |format|
      format.html
      format.csv { send_data to_csv(@results)}
      format.xls 
    end
  end
  
  
  def item_usage
    select_item_fields = "items.title, items.id, items.callnumber, items.isbn, items.source"
    select_item_connections_fields = "count(item_connections.student_id) as assigned_count, item_connections.created_at as assigned_at"
    select_fields = select_item_connections_fields + ", " + select_item_fields
    
    sql = 'SELECT ' + select_fields + ' FROM "item_connections" INNER JOIN  "items" ON "item_connections"."item_id" = "items"."id" GROUP BY item_connections.item_id'
    @assigned_items = ActiveRecord::Base.connection.execute(sql)
    @items_count = Item.count
    
    @unassigned_items = Item.where("id not in (?)", @assigned_items.collect{ |i| i["id"] })
  end

  private
  def authorize_check
     authorize! :show, :stats
  end
  
  def to_csv(data)
    require 'csv'
    
    CSV.generate(Hash.new) do |csv|
      added_headers = false  

      data.each do |result|
        if result.is_a?(Student)
          unless added_headers
            csv << %w(id name email student_number cds_adviser created_on)
            added_headers = true
          end
          csv << result.to_csv
        end
      end
    end
    
  end
end
