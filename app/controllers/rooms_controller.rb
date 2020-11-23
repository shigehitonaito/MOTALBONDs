class RoomsController < ApplicationController

	before_action :authenticate_user!
	before_action :room_check, only: [:create]


	def create
		@room.save
		current_user_entry = current_user.entries.create(room_id: @room.id)
		user_entry = @user.entries.create(room_id: @room.id)
		redirect_to dms_users_path(room_id: @room.id)
	end

	private


	def room_check
		@user = User.find(params[:user_id])
		user_entries = @user.entries
		unless current_user.entries.count == 0 || user_entries.count == 0
			current_user.entries.each do |current_user_entry|
				user_entries.each do |user_entry|
					if current_user_entry.room_id == user_entry.room_id
						p "既にチャットルームがあります。"
						@room = Room.find(current_user_entry.room.id)
						redirect_to dms_users_path(room_id: current_user_entry.room_id)
					end
				end
			end
			if @room == nil
				p "チャットルームを作成します。"
				@room = Room.new
			end
		else
			p "チャットルームがなく初めてのチャットなのでチャットルームを作成します。"
			@room = Room.new
		end
	end

end
