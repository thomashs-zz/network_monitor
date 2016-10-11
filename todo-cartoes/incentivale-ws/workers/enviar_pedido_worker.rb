require 'httparty'
require 'sidekiq'
require 'tracking_do_pedido_worker'

class EnviarPedidoWorker
	include Sidekiq::Worker
	
	def perform(json)

		#
		# for each card option in app manager's
		# calls for incentivale endpoint
		#

		errors = 0

		json['card_options'].each do |card_item|
		
			data = {
				'Token' => INCENTIVALE_TOKEN,
				'CodRequest' => json['identifier'],
				'SKU' => card_item['sku'],
				'Name' => (json['user']['first_name'] + ' ' + json['user']['last_name']),
				'CPF_CNPJ' => json['user']['document'],
				'Email' => json['user']['email'],
				'Address' => json['order']['delivery_address'],
				'AddressNumber' => json['order']['delivery_address'],
				'AddressComplement' => json['order']['delivery_number'],
				'District' => json['order']['delivery_neighbourhood'],
				'City' => json['order']['delivery_city'],
				'State' => json['order']['delivery_state'],
				'CEP' => json['order']['delivery_cep'],
				'PhoneContact' => (json['order']['phone_ddd'] + ' ' + json['order']['phone_number'])
			}

			#
			# posts to Incentivale Endpoint
			#
			response = HTTParty.post(INCENTIVALE_ENVIAR_PEDIDO_URL, body: data, headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
			response_json = JSON(response)

			#
			# manda status de 'iniciado para o app manager'
			# ou envia para o bugsnag
			#
			if response_json['CodeReturn'] == '1'

				# aba bugsnag
				Bugsnag.before_notify_callbacks << lambda { |notification|
		      notification.add_tab(:incentivale_response, {
		        '$id' => response_json['$id'],
						'CodeReturn' => response_json['CodeReturn'],
						'MessageReturn' => response_json['MessageReturn'],
						'PricePremium' => response_json['PricePremium'],
						'PriceFreight' => response_json['PriceFreight'],
						'PriceTotalRequest' => response_json['PriceTotalRequest'],
						'CodRequest' => response_json['CodRequest']
		      })
		    }

				# notify bugsnag
				Bugsnag.notify('Incentivale Enviar Pedido')

				errors += 1

			end
		end
		
		if errors == 0
			#
			# sends 'iniciado' to app manager
			#
			data = {
				'identifier' => json['order']['identifier'],
				'status' => 'iniciado',
				'code' => ''
			}
			headers = {
				'Authorization' => "Token #{APP_MANAGER_API_KEY}",
				'Content-Type' => 'application/json'
			}
			HTTParty.post(APP_MANAGER_UPDATE_LOGISTIC_STATUS_URL, body: data, headers: headers)

			#
			# starts tracking daemon
			#
			TrackingDoPedidoWorker.perform_in(30.minutes,json['identifier'])
			
		end

	end

end