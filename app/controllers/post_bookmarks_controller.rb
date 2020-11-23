class PostBookmarksController < ApplicationController
	before_action :authenticate_user!
	
	def create
		@post_bookmark = current_user.post_bookmarks.new(post_id: params[:post_id])
		@post_bookmark.save
	end

	def destroy
		@post_bookmark = PostBookmark.find_by(post_id: params[:post_id], user_id: current_user.id)
		@post_bookmark.destroy
	end
end
