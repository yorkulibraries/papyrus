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
