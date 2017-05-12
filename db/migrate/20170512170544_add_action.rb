class AddAction < ActiveRecord::Migration[5.0]
  def change
    add_column :records, :actionRequiredBy, :text
  end
end
