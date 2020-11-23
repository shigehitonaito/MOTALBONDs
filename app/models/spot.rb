class Spot < ApplicationRecord


	attachment :spot_image, destroy: false
	geocoded_by :address
 	after_validation :geocode, if: :address_changed?
 	Geocoder.configure(language: :ja)
 	reverse_geocoded_by :latitude, :longitude
	after_validation :reverse_geocode

	before_create :output_prefecture

 	validates :place,  presence: true,  length: { maximum: 20 }
 	validates :address,  presence: true
 	validates :body,  length: { maximum: 50 }

	belongs_to :user
	has_many :spot_favorites, dependent: :destroy
	has_many :spot_bookmarks, dependent: :destroy



	def favorited_by?(user)
		self.spot_favorites.where(user_id: user.id).exists?
	end

	def bookmarked_by?(user)
		self.spot_bookmarks.where(user_id: user.id).exists?
	end

	def swap(a,b)
		self.address[a], self.address[b] = self.address[b], self.address[a]
	end

	def output_prefecture
		addresses = self.address.split(",")
		addresses.each do |address|
			if address.end_with?('県', '東京都', '大阪府','京都府', '北海道') then
				self.prefecture = address.strip
				break
			end
		end
	end




end

