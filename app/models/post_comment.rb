class PostComment < ApplicationRecord

	validates :user_id,  presence: true
	validates :post_id,  presence: true
	validates :body,  length: { in: 1..200 }

	belongs_to :user
	belongs_to :post
end
