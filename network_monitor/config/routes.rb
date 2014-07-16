NetworkMonitor::Application.routes.draw do
  root :to => "application#index"
  resources :devices
  get '/run/:id' => 'ajax#run', as: 'run'
end
