Nutrisuporte::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  devise_for :users, controllers: { 
    registrations: "registrations"
  }

  # homepage
  root to: 'application#index'

  # product
  get '/produto/:slug' => 'products#show', as: 'product'
  get '/produtos/:slug' => 'products#category', as: 'product_category'
  get '/produtos/:x/:slug' => 'products#category', as: 'product_category_nested' # the x on the URL is irrelephant :)
  get '/marcas/:slug' => 'products#brand', as: 'product_brand'
  get '/busca' => 'products#search', as: 'search'
  get '/promocoes' => 'products#deals', as: 'deals'
  get '/shipping-calculator' => 'products#shipping_calculator', as: 'product_shipping_calculator'
  get '/total-calculator' => 'products#total_calculator', as: 'product_total_calculator'
  post '/product-subscription' => 'products#product_subscription', as: 'product_subscription'
  get '/auto-complete-search' => 'products#auto_complete_search', as: 'auto_complete_search'

  # static pages
  get '/quem-somos' => 'application#about', as: 'about'
  get '/termos-de-uso' => 'application#terms_of_use', as: 'terms_of_use'
  get '/contato' => 'contact#new', as: 'contact'
  post '/contato' => 'contact#create', as: 'contact'

  # blog
  get '/blog' => 'blog#index', as: 'blog'
  get '/blog/:slug' => 'blog#show', as: 'blog_show'

  # user account
  get '/meus-dados' => 'users#account', as: 'user_account'
  get '/editar-meus-dados' => 'users#edit', as: 'edit_user_account'
  put '/editar-meus-dados' => 'users#update', as: 'update_user_account'
  get '/meus-pedidos' => 'users#orders', as: 'user_orders'
  get '/meus-pedidos/:id' => 'users#order', as: 'user_order'

  # cart (carrinho)
  get '/carrinho' => 'cart#index', as: 'cart'
  match '/cart/add' => 'cart#add', as: 'cart_add'
  match '/cart/set_qty' => 'cart#set_qty', as: 'cart_set_qty'
  match '/cart/remove/:product_type_id' => 'cart#remove', as: 'cart_remove'
  get '/cart/shipping-selector' => 'cart#shipping_selector', as: 'cart_shipping_selector'
  get '/cart/save-shipping-option' => 'cart#save_shipping_option', as: 'save_shipping_option'
  get '/cart/clear-cart' => 'cart#clear_cart', as: 'cart_clear'
  
  # checkout
  get '/resumo' => 'checkout#index', as: 'checkout'
  get '/alterar-endereco' => 'checkout#change_address_and_return', as: 'checkout_change_address'
  get '/save-address-id' => 'checkout#save_user_address_id', as: 'checkout_save_user_address_id'
  get '/adicionar-endereco' => 'checkout#add_address', as: 'checkout_add_address'

  # checkout payment
  get '/pagamento' => 'checkout#payment', as: 'checkout_payment'
  get '/get-token' => 'checkout#get_token', as: 'checkout_payment_get_token'
  get '/deposit' => 'checkout#pay_with_deposit', as: 'checkout_payment_deposit'

  # post moip
  post '/moip-nasp' => 'moip#nasp'

end
