class UsersController < ApplicationController
	before_action :authenticate_user!, except: [:show]
	before_action :correct_user, only: [:edit, :update, :image_destroy]

	def show
		@user = User.find(params[:id])
		@posts = @user.posts.order(id: "DESC")
		@spots = @user.spots.order(id: "DESC")
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update(user_params)
			redirect_to user_path(@user.id)
		else
			render "edit"
		end
	end

	def image_destroy
		user = User.find(params[:id])
		user.update(profile_image: nil)
		redirect_to user_path(user.id)
	end


	def followings
		@user = User.find(params[:id])
		@users = @user.followings
	end

	def followers
		@user = User.find(params[:id])
		@users = @user.followers
	end

	def bookmarks
		@user = User.find(current_user.id)
		@posts = @user.bookmarking_posts.includes(:user, :post_favorites, :post_bookmarks)
		@spots = @user.bookmarking_spots.includes(:user, :spot_favorites, :spot_bookmarks)
	end

	def my_events
		@events = current_user.events.order(at_date: "ASC")
		@event = Event.new
	end

	def dms
		@user = User.find(current_user.id)
		@users = current_user.followings & current_user.followers
		@rooms = current_user.chat_rooms
		@message = Message.new
	 	@room = nil
	 	if current_user.chat_rooms.count != 0
		 	last_message_id = 0
		 	current_user.chat_rooms.each do |chat_room|
		 		if chat_room.messages.count != 0
			 		if chat_room.messages.last.id > last_message_id
			 			last_message_id = chat_room.messages.last.id
			 		end
			 	end
		 	end
		 	unless last_message_id == 0
			 	last_message = Message.find(last_message_id)
			 	@room = Room.find(last_message.room_id)
			 else
			 	@room = current_user.chat_rooms.last
			 end
		 end
		if params[:room_id]
			@room = Room.find(params[:room_id])
		end
		if params[:search_user]
			@users = User.where("nickname LIKE?", '%' + params[:search_user] + '%')
		end
		if params[:user_id]
			@user = User.find(params[:user_id])
		end
	end



	private
	def user_params
		params.require(:user).permit(:nickname, :profile_image, :introduction, :name, :email, :birthday)
	end

	def correct_user
		user = User.find(params[:id])
		if user.id != current_user.id
			flash[:not_correct] = "不正アクセス"
			redirect_to user_path(current_user.id)
		end
	end
end
