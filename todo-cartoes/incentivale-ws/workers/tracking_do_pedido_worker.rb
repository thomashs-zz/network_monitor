require ''

class TrackingDoPedidoWorker
	include Sidekiq::Worker

	def perform(identifier)

		data = {
			'Token' => INCENTIVALE_TOKEN,
			'CodRequest' => identifier
		}
		#
		# sends request to incentivale endpoint
		#

		response = HTTParty.post(INCENTIVALE_TRACKING_DO_PEDIDO_URL, body: data, headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
		response_json = JSON(response)

		#
		# manda status de 'iniciado para o app manager'
		# ou envia para o bugsnag
		#
		if response_json['CodeReturn'] == '1'

			Bugsnag.before_notify_callbacks << lambda { |notification|
	      notification.add_tab(:incentivale_response, {
	        '$id' => response_json['$id'],
					'CodeReturn' => response_json['CodeReturn'],
					'MessageReturn' => response_json['MessageReturn'],
					'DateRequest' => response_json['DateRequest'],
					'DateDelivery' => response_json['DateDelivery'],
					'StatusId' => response_json['StatusId'],
					'Note' => response_json['Note'],
					'Label' => response_json['Label']
	      })
	    }

	    Bugsnag.notify('Incentivale Tracking do Pedido')

		else

			# 
			# testa StatusId se estiver no continue_statuses p/ continuar chamando recursivamente
			#

			continue_statuses = []

			if continue_statuses.include? response_json['StatusId'].to_i 
				TrackingDoPedidoWorker.perform_in(30.minutes,identifier)
			end

			#
			# notificar app manager
			#

			# from incentivale to app manager's
			status_translations = {

				# 1 - PENDENTE (continua)
				# 2 - CODIFICADO (continua)
				# 3 - ENTREGUE
				# 4 - DEVOLVIDO 
				# 5 - ENCAMINHADO 
				# 6 - EXTRAVIO 
				# 7 - CANCELADO 
				# 8 - OUTRO 
				# 9 - AGUARDANDO RETIRADA NA AGÊNCIA 

				'1' => '',
				'2' => '',
				'3' => '',
				'4' => '',
				'5' => '',
				'6' => '',
				'7' => '',
				'8' => '',
				'9' => ''
			}

			#
			# get status no app manager e se for diferente 
			#
			response = HTTParty.get("#{APP_MANAGER_GET_LOGISTIC_STATUS_URL}?identifier=#{identifier}",headers: { 'Authorization' => "Token #{APP_MANAGER_API_KEY}" })
			response_json = JSON(response)

			status_translated = status_translations[ response_json['StatusId'] ]

			if response_json['success'] and response_json['status'] != status_translated

				#
				# sends 'iniciado' to app manager
				#
				data = {
					'identifier' => json['order']['identifier'],
					'status' => status_translated,
					'code' => '' # PRECISA COLOCAR CODE DE TRACKING AQUI,
					'metadata' => {
						'colocar todos os dados do response' => 'aqui',
						'lalala' => 'xxx'
					}
				}
				headers = {
					'Authorization' => "Token #{APP_MANAGER_API_KEY}",
					'Content-Type' => 'application/json'
				}
				HTTParty.post(APP_MANAGER_UPDATE_LOGISTIC_STATUS_URL, body: data, headers: headers)

			end

		end

	end

end