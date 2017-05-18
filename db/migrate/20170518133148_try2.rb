class Try2 < ActiveRecord::Migration[5.0]
  def change
    add_column :records, :fullChangelog, :text
  end
end
