class TodoListsController < AuthenticatedController
  authorize_resource
  before_action :load_todo_list, except: [:index, :create, :new]

  def index

    if params[:which] == TodoList::STATUS_DONE
      @todo_lists = TodoList.completed
    else
      @todo_lists = TodoList.not_completed
    end

  end

  def new
    @todo_list = TodoList.new
  end

  def edit
  end

  def create
    @todo_list =  TodoList.new(todo_list_params)
    @todo_list.created_by = current_user
    @todo_list.audit_comment = "Adding a new Todo List"
    @todo_list.status = TodoList::STATUS_NEW

    if @todo_list.save
      respond_to do |format|
        format.html { redirect_to @todo_list, notice: "Successfully created Todo List" }
        format.js
      end
    else
      respond_to do |format|
        format.html { render action: 'new' }
        format.js
      end
    end

  end

  def update

    @todo_list.audit_comment = "Updating Todo List"
    if @todo_list.update_attributes(todo_list_params)
      respond_to do |format|
        format.html { redirect_to  @todo_list, notice: "Successfully updated scan list." }
        format.js
      end
    else
      respond_to do |format|
        format.html { render action: 'edit' }
        format.js
      end
    end
  end

  def destroy
    @todo_list.audit_comment = "Removed Todo List"
    @todo_list.destroy


    respond_to do |format|
      format.html { redirect_to todo_lists_path, notice: "Successfully removed Todo List" }
      format.js
    end
  end



  private
  def todo_list_params
    params.require(:todo_list).permit(:name, :status, :assigned_to_id)
  end

  def load_todo_list
    @todo_list = TodoList.find(params[:id])
  end

end
