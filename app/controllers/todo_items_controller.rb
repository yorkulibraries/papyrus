# frozen_string_literal: true

class TodoItemsController < AuthenticatedController
  authorize_resource
  before_action :load_todo_list
  protect_from_forgery except: %i[new edit]

  def new
    @todo_item = @todo_list.todo_items.new
    @todo_item.item_id = params[:item_id] if params[:item_id]
  end

  def create
    @todo_item = @todo_list.todo_items.new(todo_item_params)
    @todo_item.created_by = current_user
    @todo_item.audit_comment = 'Adding a new Todo Item'
    @todo_item.status = TodoItem::STATUS_NEW

    if @todo_item.save
      respond_to do |format|
        format.html { redirect_to [@todo_list, @todo_item], notice: 'Successfully created Todo Item' }
        format.js
      end
    else
      respond_to do |format|
        format.html { render action: 'new' }
        format.js
      end
    end
  end

  def edit
    @todo_item = @todo_list.todo_items.find(params[:id])
  end

  def update
    @todo_item = @todo_list.todo_items.find(params[:id])
    @todo_item.audit_comment = 'Updating Todo Item'

    if @todo_item.update(todo_item_params)
      respond_to do |format|
        format.html { redirect_to [@todo_list, @todo_item], notice: 'Successfully updated scan item.' }
        format.js
        format.json { render json: @todo_item }
      end
    else
      respond_to do |format|
        format.html { render action: 'edit' }
        format.js
        format.json { render json: @todo_item }
      end
    end
  end

  def destroy
    @todo_item = @todo_list.todo_items.find(params[:id])
    @todo_item.audit_comment = 'Removed Todo List'
    @todo_item.destroy

    respond_to do |format|
      format.html { redirect_to [@todo_list, @todo_item], notice: 'Successfully removed Todo Item' }
      format.js
    end
  end

  private

  def load_todo_list
    @todo_list = TodoList.find(params[:todo_list_id])
  end

  def todo_item_params
    params.require(:todo_item).permit(:summary, :status, :assigned_to_id, :item_id, :due_date)
  end
end
