class DeletingChanges < ActiveRecord::Migration[5.0]
  def change
    remove_column :records, :changes
  end
end
