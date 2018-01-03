class ChangeCompletedDefaultToFalse < ActiveRecord::Migration
  def change
    change_column_default :items, :completed, false
  end
end
