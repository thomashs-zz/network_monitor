class BlogController < ApplicationController
	def index
		@blog_items = BlogPost.published.page(params[:page])
	end
	def show
		@blog_item = BlogPost.find_by_url(params[:slug])
	end
end