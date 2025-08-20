class TodosController < ApplicationController
  def index
    @todos = Todo.recent
    @todo = Todo.new
    @total_count = Todo.count
    @completed_count = Todo.completed.count
    @pending_count = Todo.pending.count
  end

  def create
    @todo = Todo.new(todo_params)
    if @todo.save
      respond_to do |format|
        format.html { redirect_to root_path }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, alert: @todo.errors.full_messages.join(", ") }
        format.turbo_stream { render turbo_stream: turbo_stream.replace("todo_form", partial: "todos/form", locals: { todo: @todo }) }
      end
    end
  end

  def destroy
  end

  private

  def todo_params
    params.require(:todo).permit(:title, :completed)
  end
end
