class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attachment :profile_image
  validates :name,  presence: true
  validates :birthday,  presence: true
  validates :nickname,  length: { in: 2..15 }
  validates :introduction,  length: { maximum: 80 }


  has_many :posts, dependent: :destroy
  has_many :post_comments, dependent: :destroy
  has_many :post_favorites, dependent: :destroy
  has_many :post_bookmarks, dependent: :destroy
  has_many :bookmarking_posts, through: :post_bookmarks, source: :post

  has_many :relationships, foreign_key: "follower_id"
  has_many :followings, source: :following, through: :relationships

  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'following_id'
  has_many :followers, source: :follower, through: :reverse_of_relationships

  has_many :spots, dependent: :destroy
  has_many :spot_favorites, dependent: :destroy
  has_many :spot_bookmarks, dependent: :destroy
  has_many :bookmarking_spots, through: :spot_bookmarks, source: :spot

  has_many :events, dependent: :destroy

  has_many :messages
  has_many :entries
  has_many :chat_rooms, through: :entries, source: :room


  def following?(another_user)
    self.followings.include?(another_user)
  end

  def follow(another_user)
	unless self == another_user
  		self.relationships.find_or_create_by(following_id: another_user.id)
  	end
  end

  def unfollow(another_user)
  	unless self == another_user
  		relationship = Relationship.find_by(following_id: another_user.id, follower_id: self.id)
  		relationship.destroy if relationship
  	end
  end

  # def preview_message
  #   last_message = 0
  #   self.chat_rooms.each do |chat_room|
  #     if chat__room.message.last.id > last_message
  #       last_message =chat_room.messages.last.id
  #     end
  #   end
  #   return last_message
  # end
end
