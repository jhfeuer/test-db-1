class ClearingProduct < ActiveRecord::Migration[5.0]
  def up
    drop_table :products    
  end
end
