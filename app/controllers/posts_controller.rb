class PostsController < ApplicationController
	before_action :authenticate_user!, except: [:index, :show, :top]
	before_action :correct_user, only: [:edit, :update]

	def top
	end

	def index
		@posts = Post.includes(:user).order(id: "DESC")
		@post = Post.new
	end

	def show
		@post = Post.find(params[:id])
		@new_post_comment = PostComment.new
		@post_comments = @post.post_comments
	end

	def create
		@post = Post.new(post_params)
		@post.user_id = current_user.id
		if @post.youtube_url == ""
			@post.youtube_url = nil
		else
			url = @post.youtube_url
			url = url.last(11)
			@post.youtube_url = url
		end
		if @post.movie.filename == nil && @post.youtube_url == nil
			flash[:post] = "動画を選択してください。"
			if @post.save
				redirect_to root_path
			else
				@posts = Post.includes(:user).order(id: "DESC")
				render "index"
			end
		elsif @post.movie.filename != nil && @post.youtube_url != nil
			flash[:post] = "複数の動画が選択されています。"
			if @post.save
				redirect_to root_path
			else
				@posts = Post.includes(:user).order(id: "DESC")
				render "index"
			end
		else
			if @post.save
				redirect_to root_path
			else
				@posts = Post.includes(:user).order(id: "DESC")
				render "index"
			end
		end
	end

	def edit
		@post = Post.find(params[:id])
	end

	def update
		@post = Post.find(params[:id])
		if @post.update(post_params)
			redirect_to post_path(@post.id)
		else
			render "edit"
		end
	end

	def destroy
		post = Post.find(params[:id])
		post.destroy
		redirect_to user_path(current_user.id)
	end

	private
	def post_params
		params.require(:post).permit(:body, :title, :movie, :youtube_url)
	end

	def correct_user
		post = Post.find(params[:id])
		unless post.user == current_user
			flash[:correct_user] = "不正アクセス"
			redirect_to root_path
		end
	end

end
