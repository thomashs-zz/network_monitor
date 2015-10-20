class MoipNasp < ActiveRecord::Base
	
	belongs_to :order, foreign_key: 'id_transacao', class_name: 'Order'
  attr_accessible :cartao_bandeira, :cartao_bin, :cartao_final, :classificacao, :cod_moip, :cofre, :email_consumidor, :forma_pagamento, :id_transacao, :parcelas, :recebedor_login, :status_pagamento, :tipo_pagamento, :valor

  @@status_pagamento_types = {
  	1 => 'Autorizado',
  	2 => 'Iniciado',
  	3 => 'Boleto Impresso',
  	4 => 'Concluido',
  	5 => 'Cancelado',
  	6 => 'Em Análise',
  	7 => 'Estornado', # there is no 8
  	9 => 'Reembolsado'
  }
  cattr_reader :status_pagamento_types
  #validates_inclusion_of :status_pagamento, :in => @@status_pagamento_types.keys
  
  @@forma_pagamento_types = {
  	'1' => 'MoIP',
  	'3' => 'Visa',
  	'7' => 'AmericanExpress',
  	'5' => 'Mastercard',
  	'6' => 'Diners',
  	'8' => 'BancoDoBrasil',
  	'22' => 'Bradesco',
  	'13' => 'Itau',
  	'73' => 'BoletoBancario',
  	'75' => 'Hipercard',
  	'76' => 'Paggo',
  	'88' => 'Banrisul'
  }
  cattr_reader :forma_pagamento_types
  #validates_inclusion_of :forma_pagamento, :in => @@forma_pagamento_types.keys

  @@tipo_pagamento_types = {
  	'BoletoBancario' => 'Boleto Bancário',
  	'CartaoDeCredito' => 'Cartão de Crédito',
  	'CartaoCredito' => 'Cartão de Crédito',
  	'DebitoBancario' => 'Débito',
  	'CartaoDeDebito' => 'Cartão de Débito',
  	'CartaoDebito' => 'Cartão de Débito',
  	'FinanciamentoBancario' => 'Financiamento Bancário',
  	'CarteiraMoIP' => 'Carteira Moip'
  }
  cattr_reader :tipo_pagamento_types
  #validates_inclusion_of :tipo_pagamento, :in => @@tipo_pagamento_types.keys
  
  after_save :trigger_order_status
  def trigger_order_status
  	if [1].include?(self.status_pagamento.to_i) and self.valor >= self.order.the_total
  		self.order.confirm!
  	elsif [5,7,9].include?(self.status_pagamento.to_i)
  		self.order.cancel!
  	elsif [2,3,6].include?(self.status_pagamento.to_i)
  		self.order.notify!
  	end
  end

end
