class AddIndexToColumn < ActiveRecord::Migration[8.0]
  def change
    add_index :todos, :completed
  end
end
