class Room < ApplicationRecord
	has_many :messages, dependent: :destroy
	has_many :entries, dependent: :destroy

	def chat_friend(user)
		self.entries.each do |entry|
			unless entry.user == user
				return entry.user
				break
			end
		end
	end
end
