require 'sinatra'
require 'incentivale'
require 'json'
require 'workers/enviar_pedido_worker'
require 'workers/tracking_do_pedido_worker'

post '/create-order' do

	EnviarPedidoWorker.perform(JSON(request.body.to_s))

end