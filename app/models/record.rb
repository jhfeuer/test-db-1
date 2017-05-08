class Record < ApplicationRecord
    validates :serialNum, presence: true
    validates :product, presence: true
    validates :removalDate, presence: true
    validates :supplier, presence: true
    validates :partNum, presence: true
end
