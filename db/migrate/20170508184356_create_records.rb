class CreateRecords < ActiveRecord::Migration[5.0]
  def change
    create_table :records do |t|
      t.string :serialNum
      t.string :product
      t.string :partNum
      t.date :removalDate
      t.string :owner
      t.string :status
      t.string :location
      t.date :resolveBy
      t.text :removalReason
      t.text :comments
      t.string :supplier
      t.string :utasPO
      t.string :pwPO
      t.string :qn
      t.boolean :resolved

      t.timestamps
    end
  end
end
