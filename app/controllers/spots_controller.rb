class SpotsController < ApplicationController
	before_action :authenticate_user!
	before_action :correct_user, only: [:edit, :update, :destroy]


	def index
		@spots = Spot.includes(:spot_favorites, :spot_bookmarks).order(id: "DESC")
		@keyword = "国内"
		@sort = "投稿順(新しい)"
		if params[:prefecture] != nil
			@spots = Spot.where(prefecture: params[:prefecture]).order(id: "DESC")
			@terms = @spots.where_values_hash
			@keyword = params[:prefecture]
  		end
  		if params[:search].present?
  			@spots = Spot.where("place LIKE?", '%' + params[:search] + '%').or(Spot.where("address LIKE?", '%' + params[:search] + '%')).order(id: "DESC")
  			@terms = {"search" => params[:search]}
  			@keyword = params[:search]
  		end
  		if params[:sort].present?
  			@sort = params[:sort]
  			if params[:key].present?
  				if params[:key]["search"].present?
  					@spots = Spot.where("place LIKE?", '%' + params[:key]["search"] + '%').or(Spot.where("address LIKE?", '%' + params[:key]["search"] + '%'))
  					@terms = {"search" => params[:key]["search"]}
  					@keyword = params[:key]["search"]
  				elsif params[:key]["prefecture"].present?
  					@spots = Spot.where(prefecture: params[:key]["prefecture"])
  					@terms = @spots.where_values_hash
  					@keyword = params[:key]["prefecture"]
  				end
  			else
  				@spots = Spot.all
  			end
  			case params[:sort]
  			when "人気順"
  				@spots = @spots.sort {|a,b| b.spot_favorites.count <=> a.spot_favorites.count}
  			when "投稿順(新しい)"
  				@spots = @spots.order(id: "DESC")
  			when "投稿順(古い)"
  				@spots = @spots.order(:id)
  			end
  		end

	end


	def show
		@spot = Spot.find(params[:id])
	end

	def new
		@spot = Spot.new
	end

	def create
		@spot = current_user.spots.new(spot_params)
		if @spot.save
			redirect_to spot_path(@spot.id)
		else
			render "new"
		end
	end

	def edit
		@spot = Spot.find(params[:id])
	end

	def update
		@spot = Spot.find(params[:id])
		if @spot.update(spot_params)
			redirect_to spot_path(@spot.id)
		else
			@error_spot = @spot
			@spot = Spot.find(params[:id])
			render "show"
		end
	end

	def destroy
		spot = Spot.find(params[:id])
		spot.destroy
		redirect_to spots_path
	end


	private
	def spot_params
		params.require(:spot).permit(:place, :spot_image, :body, :wheather, :address)
	end

	def correct_user
		spot = Spot.find(params[:id])
		unless spot.user == current_user
			flash[:correct_user] = "不正アクセス"
			redirect_to root_path
		end
	end
end
