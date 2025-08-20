class UpdateTodosConstraints < ActiveRecord::Migration[8.0]
  def change
    change_column_null :todos, :title, false
    change_column :todos, :completed, :boolean, null: false, default: false
  end
end
