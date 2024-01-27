class AddUserToLabels < ActiveRecord::Migration[6.0]
  def change
    add_reference :labels, :user, null: false, foreign_key: true, default: 24
  end
end
