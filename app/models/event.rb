class Event < ApplicationRecord

	validates :place,  presence: true,	length: { maximum: 20 }
	validates :at_date,  presence: true

	belongs_to :user
end
