class RemoveDefaultFromPriorityAndStatus < ActiveRecord::Migration[6.0]
  def change
    change_column_default :tasks, :priority, from: 0, to: nil
    change_column_default :tasks, :status, from: 0, to: nil
  end
end

