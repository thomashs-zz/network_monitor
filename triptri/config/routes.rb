Rails.application.routes.draw do
	
	# admin webservice
  devise_for :admin_users, ActiveAdmin::Devise.config
  get '/admin/users/auto-complete' => 'admin/users#search'
  ActiveAdmin.routes(self)
  get '/admin/trips/:id/get_board_places' => 'admin/trips#get_board_places', as: 'get_board_places_admin_trips'
  
  devise_for :users, :controllers => { :registrations => "users/registrations" }

  # user routes
  get '/minhas-compras' => 'users#index', as: 'user_orders'

  root to: 'index#index'

  get '/agenda' => 'schedule#index', as: 'schedule'
  get '/trip/:url' => 'trips#index', as: 'trip'
  get '/termos-de-uso' => 'application#terms', as: 'terms'
  get '/viaje-sem-duvidas' => 'application#doubts', as: 'doubts'
  get '/fale-conosco' => 'application#contact', as: 'contact'
  
  # checkout
  get '/compra/:url' => 'checkout#new', as: 'checkout'
  post '/compra/:url' => 'checkout#create', as: 'create_order'

  # 
  get '/pagamento/:id_hash' => 'checkout#payment', as: 'payment'
  get '/atualizar-e-voltar-para-compra' => 'checkout#update_and_go_back_to_checkout', as: 'update_and_go_back_to_checkout'

  # notifications pagseguro
  post '/pagseguro' => 'pagseguro#create', as: 'pagseguro'
  get '/detalhes-compra/:id_hash' => 'orders#show', as: 'order_return'
  get '/detalhes-compra' => 'orders#show'

  # cronjob pre-trip
  get '/pre-trip-mailer' => 'order#pre_trip_mailer'

  # email marketing
  get '/email-marketing' => 'mailchimp#subscribe', as: 'email_marketing'

end