class SpotBookmark < ApplicationRecord

	validates :user_id,  presence: true
	validates :spot_id,  presence: true

	belongs_to :user
	belongs_to :spot
end
