class PostCommentsController < ApplicationController

	before_action :authenticate_user!
	def create
		@post_comment = current_user.post_comments.new(comment_params)
		@post_comment.post_id = params[:post_id]
		@post_comment.save
	end

	def destroy
		@post_comment = PostComment.find(params[:id])
		@post_comment.destroy
	end

	private
	def comment_params
		params.require(:post_comment).permit(:body)
	end
end
