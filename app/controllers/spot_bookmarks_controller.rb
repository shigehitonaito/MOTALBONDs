class SpotBookmarksController < ApplicationController
	before_action :authenticate_user!
	def create
		@spot_bookmark = current_user.spot_bookmarks.new(spot_id: params[:spot_id])
		@spot_bookmark.save
	end

	def destroy
		@spot_bookmark = SpotBookmark.find_by(spot_id: params[:spot_id], user_id: current_user.id)
		@spot_bookmark.destroy
	end
end
