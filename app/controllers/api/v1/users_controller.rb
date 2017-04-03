class Api::V1::UsersController < Api::V1::BaseController

  def index
    which = params[:which]

    if params[:fields].blank?
      fields = [:id, :first_name, :last_name, :username]
    else
      fields = params[:fields].split(",").map { |f| f.to_sym }
    end

    begin

      if which == "students"
        @users = Student.unblocked.includes(:student_details_only_student_number).pluck(*fields)
      elsif which == "admins"
        @users =  User.unblocked.not_students.pluck(*fields)
      elsif is_number?(which)
        @users = Student.unblocked.includes(:student_details_only_student_number).where("student_details.student_number = ? ", which).pluck(*fields)
      else
        @users = User.unblocked.pluck(*fields)
      end
      
    rescue
      @users = []
    end


    respond_to do |format|
      format.json { render json: @users }
      format.text { render text: @users.collect { |u| u.kind_of?(Array) ? u.join("\t") : u  }.join("\n") }
    end
  end


  def info
    preamble = "USERS API v1.0"
    index = "LIST: #{api_v1_users_path}(.format[json|text])?which=[students|admin|all]&fields=[default all, list comma separated]"

    info = [preamble, index]
    render plain: info.join("\n---\n");
  end

  private
  def is_number? string
    true if Float(string) rescue false
  end
end
