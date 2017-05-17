class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :prodName
      t.string :prodNum
      t.string :prodSupplierNum
      t.string :prodUTASowners
      t.string :prodSupplier

      t.timestamps
    end
  end
end
