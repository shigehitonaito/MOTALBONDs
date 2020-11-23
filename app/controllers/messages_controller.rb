class MessagesController < ApplicationController
	before_action :authenticate_user!

	def create
		message = current_user.messages.new(message_params)
		message.room_id = params[:room_id]
		message.save
		@room = Room.find(params[:room_id])
		@message = Message.new
	end

	private

	def message_params
		params.require(:message).permit(:content)
	end
end
