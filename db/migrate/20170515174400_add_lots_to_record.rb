class AddLotsToRecord < ActiveRecord::Migration[5.0]
  def change
    add_column :records, :d3QN, :string
    add_column :records, :v2QN, :string
    add_column :records, :removalLocation, :string
    add_column :records, :program, :string
    add_column :records, :dateResolved, :date
  end
end
