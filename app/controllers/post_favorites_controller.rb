class PostFavoritesController < ApplicationController
	before_action :authenticate_user!

	def create
		@post_favorite = current_user.post_favorites.new(post_id: params[:post_id])
		@post_favorite.save
	end

	def destroy
		@post_favorite = PostFavorite.find_by(post_id: params[:post_id], user_id: current_user.id)
		@post_favorite.destroy
	end


end
