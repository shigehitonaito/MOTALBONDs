class SpotFavoritesController < ApplicationController

	before_action :authenticate_user!

	def create
		@spot_favorite = current_user.spot_favorites.new(spot_id: params[:spot_id])
		@spot_favorite.save
	end

	def destroy
		@spot_favorite = SpotFavorite.find_by(spot_id: params[:spot_id], user_id: current_user.id)
		@spot_favorite.destroy
	end
end
