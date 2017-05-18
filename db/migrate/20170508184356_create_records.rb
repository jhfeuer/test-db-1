class CreateRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :records do |t|
      t.string :serialNum
      t.string :product
      t.string :partNum
      t.date :removalDate
      t.string :owner
      t.string :status
      t.text :removalReason
      t.text :comments
      t.string :supplier
      t.string :utasPO
      t.string :pwPO
      t.string :qn
      t.boolean :resolved
      t.text :actionRequiredBy
      t.string :d3QN
      t.string :v2QN
      t.string :removalLocation
      t.string :program
      t.date :dateResolved
      t.text :fullChangelog

      t.timestamps
    end
  end
end
