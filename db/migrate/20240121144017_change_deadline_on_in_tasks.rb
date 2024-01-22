class ChangeDeadlineOnInTasks < ActiveRecord::Migration[6.0]
  def change
    def up
      change_column_default(:tasks, :deadline_on, nil)
    end
  
    def down
      change_column_default(:tasks, :deadline_on, '2024-01-19')
    end
  end
end
