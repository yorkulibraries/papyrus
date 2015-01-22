class StatsController < ApplicationController
  before_filter :authorize_check

  def index
    @has_attachments_count = Attachment.distinct.count("item_id")
    @has_students_count = ItemConnection.distinct.count("item_id")

  end

  def generate


    if params[:assigned_to] != nil && params[:assigned_to] != "all"
      id = params[:assigned_to]
      assigned_to = User.find(id)
      @title = "Students Assgined to #{assigned_to.name}"
      @results = Student.includes(:student_details).joins(:student_details).where("transcription_coordinator_id = ? or transcription_assistant_id = ?", id, id)
    else
      @title = "All Students"
      @results =  Student.active.includes(:student_details).joins(:student_details)
    end

    respond_to do |format|
      format.html
      format.csv { send_data to_csv(@results) }
      format.xls
    end
  end


  def item_usage

    @start_date = params["start_date"] || Date.parse("2009-01-31")
    @end_date = params["end_date"] || Date.today
    @end_date = Date.parse(@end_date) if @end_date.is_a? String

    select_item_fields = "items.title, items.id, items.callnumber, items.isbn, items.source"
    select_item_connections_fields = "count(item_connections.student_id) as assigned_count, item_connections.created_at as assigned_at"
    select_fields = select_item_connections_fields + ", " + select_item_fields
    where_clause = "where item_connections.created_at >= '#{@start_date}' AND item_connections.created_at < '#{@end_date + 1.day}'"

    sql = "SELECT #{select_fields} FROM item_connections INNER JOIN items ON item_connections.item_id = items.id #{where_clause} GROUP BY item_connections.item_id"

    @export_items = @assigned_items = ActiveRecord::Base.connection.exec_query(sql)


    @items_count = Item.count

    @unassigned_items = Item.where("id not in (?)", @assigned_items.collect{ |i| i["id"] })

    respond_to do |format|
      format.html
      format.xls
    end
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
            csv << %w(id name email student_number preferred_formats cds_adviser created_on)
            added_headers = true
          end
          csv << result.to_csv
        end
      end
    end

  end
end
