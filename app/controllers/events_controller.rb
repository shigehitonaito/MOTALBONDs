class EventsController < ApplicationController

	before_action :correct_user, except: [:create]


	def show
		@event = Event.find(params[:id])
	end

	def create
		@event = current_user.events.new(event_params)
		if @event.save
			redirect_to my_events_users_path
		else
			@events = current_user.events.order(at_date: "ASC")
			render "users/my_events"
		end
	end

	def edit
		@event = Event.find(params[:id])
	end

	def update
		@event = Event.find(params[:id])
		if @event.update(event_params)
			redirect_to my_events_users_path
		else
			render "show"
		end
	end

	def destroy
		event =  Event.find(params[:id])
		event.destroy
		redirect_to my_events_users_path
	end

	private
	def event_params
		params.require(:event).permit(:place, :at_date)
	end

	def correct_user
		event = Event.find(params[:id])
		unless event.user == current_user
			flash[:correct_user] = "不正アクセス"
			redirect_to root_path
		end
	end

end
