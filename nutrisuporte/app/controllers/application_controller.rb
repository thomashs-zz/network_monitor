class ApplicationController < ActionController::Base
  
  protect_from_forgery
  before_filter :load_slider_items, only: [:index]
  before_filter :load_categories
  before_filter :set_cart_size
  
  def index
		load_slider_items
    @products = Product.featured
  end
  
  private
  def load_slider_items
  	@slider_brands = Brand.available
  	@slider_items = SliderHomeItem.available.order(:relevance)
  end
  
  def load_categories
  	@categories = ProductCategory.roots
  end

  def set_cart_size
    if session[:cart]
      @cart = Hash[session[:cart]]
      @cart_size = @cart.size
    else
      @cart_size = 0
    end
  end

end
