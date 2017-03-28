class Api::V1::UsersController < Api::V1::BaseController

  def index
    which = params[:which]
    fields = params[:fields]
    fields = [:id, :first_name, :last_name, :username, :role].join(",") if fields.blank?

    if which == "students"
      @users = Student.unblocked.includes(:student_details).pluck(fields)
    elsif which == "admin"
      @users =  User.unblocked.not_students.pluck(fields)
    else
      @users = User.unblocked.pluck(fields)
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
end
