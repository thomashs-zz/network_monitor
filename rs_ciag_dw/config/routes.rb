Rails.application.routes.draw do
	devise_for :users
	resources :reports
	root to: 'application#index'
	post '/execute_mdx' => 'application#execute_mdx', as: 'execute_mdx'
end