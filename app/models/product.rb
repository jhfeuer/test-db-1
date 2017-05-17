class Product < ApplicationRecord
  
  scope :numAssociatedWithPart, -> (prodName) { where(prodName: prodName) }
  
  validates :prodName, length: { maximum: 16 }, presence: true
  validates :prodNum, length: { maximum: 16 }, presence: true
  validates :prodSupplier, length: { maximum: 16 }, presence: true
end
