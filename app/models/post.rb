class Post < ApplicationRecord

	mount_uploader :movie, MovieUploader

	validates :title,  presence: true,  length: { maximum: 20 }
	validates :body,  length: { maximum: 400 }

	belongs_to :user
	has_many :post_comments, dependent: :destroy
	has_many :post_favorites, dependent: :destroy
	has_many :post_bookmarks, dependent: :destroy

	def favorited_by?(user)
		self.post_favorites.where(user_id: user.id).exists?
	end

	def bookmarked_by?(user)
		self.post_bookmarks.where(user_id: user.id).exists?
	end

end
