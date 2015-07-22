class StatsController < ApplicationController
  before_filter :authorize_check

  def index
    @has_attachments_count = Attachment.distinct.count("item_id")
    @has_students_count = ItemConnection.distinct.count("item_id")

  end

  def assigned_students
    @coordinator = User.find_by_id(params[:coordinator]) || nil
    @assistant = User.find_by_id(params[:assistant]) || nil
    @start_date = params["start_date"] || Date.parse("2009-01-31")
    @end_date = params["end_date"] || Date.today
    @end_date = Date.parse(@end_date) if @end_date.is_a? String

    @students = Student.includes(:student_details).joins(:student_details).where("users.created_at >= ? AND users.created_at < ?", @start_date, @end_date)

 
    @students = @students.where("transcription_coordinator_id = ?", @coordinator.id) unless @coordinator == nil
    @students = @students.where("transcription_assistant_id = ?", @assistant.id) unless @assistant == nil

    respond_to do |format|
      format.html
      format.xlsx
    end
  end


  def item_usage

    @start_date = params["start_date"] || Date.parse("2009-01-31")
    @end_date = params["end_date"] || Date.today
    @end_date = Date.parse(@end_date) if @end_date.is_a? String
    @source = params["source"] || nil
    @items_count = Item.count

    select_item_fields = "items.title, items.id, items.callnumber, items.isbn, items.source, items.created_at"
    select_item_connections_fields = "count(item_connections.student_id) as assigned_count, item_connections.created_at as assigned_at"
    select_fields = select_item_connections_fields + ", " + select_item_fields

    where_clause = "where item_connections.created_at >= '#{@start_date}' AND item_connections.created_at < '#{@end_date + 1.day}'"

    where_clause = where_clause + " AND items.source = '#{@source}'"  unless @source == nil || @source == "All"

    sql = "SELECT #{select_fields} FROM item_connections INNER JOIN items ON item_connections.item_id = items.id #{where_clause} GROUP BY item_connections.item_id"

    @assigned_items = ActiveRecord::Base.connection.exec_query(sql)

    @unassigned_items = Item.where("id not in (?)", @assigned_items.collect{ |i| i["id"] })


    respond_to do |format|
      format.html
      format.xlsx
    end
  end

  def items_history
    @start_date = params["start_date"] || Date.today - 1.year
    @end_date = params["end_date"] || Date.today
    @end_date = Date.parse(@end_date) if @end_date.is_a? String
    @source = params["source"] || nil

    @items_count = Item.count

    @items = Item.where("created_at >= ? AND created_at < ?", @start_date, @end_date)

    @items = @items.where("source = ?", params["source"]) unless @source == nil || @source == "All"


    respond_to do |format|
      format.html
      format.xlsx {
        render xlsx: "items_history", filename: "report_items_history.xlsx"
      }
    end

  end

  private
  def authorize_check
     authorize! :show, :stats
  end

end
