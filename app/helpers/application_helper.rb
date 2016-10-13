module ApplicationHelper
	def custom_error_messages_for(model)
    return '' if model.errors.empty?
    messages = model.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
    <div class="alert alert-danger"> 
      <button type="button" class="close" data-dismiss="alert">x</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end
end
