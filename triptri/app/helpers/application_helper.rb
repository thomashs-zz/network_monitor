module ApplicationHelper

  include Redcarpet

	def month_name(i)
		['','Janeiro','Fevereiro','Março','Abril','Maio','Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'][i]
	end

	def fancy_link_to name, options = {}, html_options = {}, &block
    klass = []
    klass << html_options[:class]
    klass << 'active' if current_page?(options)
    html_options[:class] = klass.compact.join(' ')
    link_to name, options, html_options, &block
  end

  def trip_date(td)
    "#{td.day} #{month_name(td.month)[0..2].upcase}"
  end

  def render_trip(trip,columns)
    %Q{
      <div class='trip-block #{columns} columns' data-url='#{trip_path(trip.url)}'>
        <div class='image-block' style='background-image:url("#{trip.picture.url(:thumb)}")'></div>
        <div class='informations'>
          <div class='price-tag'>
            #{fancy_number_to_currency(trip.price)}
          </div>
          <div class='trip-date'>
            #{trip_date(trip.trip_date)}
          </div>
        </div>
        <div class="details">
          <p class='title'><b>#{link_to trip.title, trip_path(trip.url)}</b></p>
          <p class='light'>#{link_to trip.destiny.description, trip_path(trip.url)}</p>
          <p class='green'>+ #{link_to 'detalhes da trip', trip_path(trip.url), class: 'blue' }</p>
        </div>
      </div>
    }.html_safe
  end

  def fancy_number_to_currency(price)
    precision = price.to_s.split('.')[1] == '0' ? 0 : 2
    number_to_currency(price,precision: precision)
  end

  def m(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new, extensions = {})
    markdown.render(text).html_safe
  end

  def pagseguro_payment_type(i)
    ['','Cartão de Crédito','Boleto','Débito Online','Saldo Pagseguro','Oi Paggo','Depósito em conta'][i]
  end

  def pagseguro_status(i)
    ['','Aguardando Pagamento','Em análise','Paga','Disponível','Em disputa','Devolvida','Cancelada','Chargeback debitado','Em contestação'][i]
  end
  
  def trip_status_tag(status)
    text = Order.status_types.invert[status]
    %Q(<span class="status-tag #{status}">Pagamento #{text}</span>).html_safe
  end

end
