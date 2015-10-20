module ApplicationHelper
	def custom_error_messages_for(model)
    return '' if model.errors.empty?
    messages = model.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
    <div id="nutrisuporte-alert-danger">
      <ul> #{messages} </ul>
    </div>
    HTML
    html.html_safe
  end

  def product_badge(product)
    if product.is_deal
      return %Q(<div class="product-list--badge oferta"></div>).html_safe
    elsif product.is_new_product
      return %Q(<div class="product-list--badge lancamento"></div>).html_safe
    end
  end

end
