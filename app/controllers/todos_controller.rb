class TodosController < ApplicationController
  def index
    @todos = Todo.recent
    @todo = Todo.new
    @total_count = Todo.count
    @completed_count = Todo.completed.count
    @pending_count = Todo.pending.count
  end

  def create
  end

  def destroy
  end
end
