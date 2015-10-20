class Order < ActiveRecord::Base
  
  belongs_to :user

  attr_accessible :id_hash,
                  :canceled_at, 
  								:delivery_address, 
                  :delivery_complement,
  								:delivery_cep, 
  								:delivery_city, 
  								:delivery_method, 
  								:delivery_name, 
  								:delivery_neighbourhood, 
  								:delivery_state, 
                  :delivery_days,
  								:is_gift,
  								:nf_number, 
  								:payed_at, 
  								:payment_address, 
                  :payment_complement,
  								:payment_cep, 
  								:payment_city, 
  								:payment_method, 
  								:payment_name, 
  								:payment_neighbourhood, 
  								:payment_state, 
                  :payments,
                  :credit_card_interest,
  								:shipped_at, 
  								:status, 
  								:total, 
  								:total_discount, 
  								:total_shipping,
  								:user_id

  validates_presence_of :total, :user_id, :payment_method, :status
  
  has_many :order_items
  accepts_nested_attributes_for :order_items

  @@payment_methods = { 
    'Cartão de Crédito' => '1', 
    'Boleto' => '2', 
    'Depósito Bancário' => '3', 
    'Outro' => '4' 
  }
  cattr_reader :payment_methods
  validates_inclusion_of :payment_method, :in => @@payment_methods.invert.keys

  @@status_types = { 
    'Aguardando Pagamento' => '1', 
    'Pago - aguardando envio' => '2', 
    'Enviado' => '3', 
    'Cancelado' => '4', 
    'Abandonou Pagamento' => '',
    'Em análise' => '5'
  }
  cattr_reader :status_types
  validates_inclusion_of :status, :in => @@status_types.invert.keys

  @@delivery_types = ['PAC','SEDEX','E-SEDEX','RETIRAR','Motoboy']
  cattr_reader :delivery_types

  has_many :order_statuses, foreign_key: 'id_transacao', class_name: 'MoipNasp'

  scope :payment_started, where("status != ''")

  attr_accessor :importing

  validate :at_least_one_item, :unless => Proc.new{ self.importing }
  def at_least_one_item
    self.errors[:base] << "Deve ter pelo menos um item no pedido" if self.order_items.size == 0
  end

  validate :check_items_availability
  def check_items_availability
    self.order_items.each do |item|
      begin
        if item.qty > (ProductType.where(product_id: item.product_id).where(name: item.product_type).first.qty)
          self.errors[:base] << "#{item.product.name} indisponível na quantidade solicitada."
        end
      rescue
        # do nothing
      end
    end
  end

  validate :check_items_weight
  def check_items_weight
    weight = 0
    self.order_items.each { |item| weight += ProductType.where(product_id: item.product_id).where(name: item.product_type).first.weight * item.qty }
    if weight > NutrisuporteSetting.max_weight
      self.errors[:base] << "Peso máximo excedido para esta compra. O máximo é #{NutrisuporteSetting.max_weight} gramas"
    end
  end

  def max_installments
    PaymentCalculator.new(self.total + self.total_shipping).max_installments
  end

  def reserve_products!
    self.order_items.each do |item|
      pt = ProductType.where(product_id: item.product_id).where(name: item.product_type).first
      pt.qty = pt.qty - item.qty
      pt.save
    end
  end

  def release_products!
    self.order_items.each do |item|
      pt = ProductType.where(product_id: item.product_id).where(name: item.product_type).first
      pt.qty = pt.qty + item.qty
      pt.save
    end
  end

  def confirm!
    if self.status != '2' and self.importing.nil?
      self.status = '2'
      self.payed_at = Time.now
      self.save
      OrderMailer.confirm(self).deliver
    end
  end

  def cancel!
    if self.status != '4' and self.importing.nil?
      self.status = '4'
      self.canceled_at = Time.now
      self.save
      release_products!
      OrderMailer.cancel(self).deliver
    end
  end

  after_save :trigger_shipping_sent_mail
  def trigger_shipping_sent_mail
    if self.status == '3' and self.importing.nil?
      OrderMailer.sent(self).deliver
    end
  end

  after_save :trigger_shipping_date
  def trigger_shipping_date
    if self.status == '3' and self.shipped_at.nil? and self.importing.nil?
      self.shipped_at = Time.now
      self.save
    end
  end

  #
  # called on starting post of moip
  # 
  def notify!
    if self.status != '5' and self.importing.nil?
      reserve_products!
      if self.order_statuses.any? and self.order_statuses.last.status_pagamento == 6
        self.status = '5'
        self.save
      end
      OrderMailer.notify(self).deliver
    end
  end

  #
  # if purchase is deposit
  #
  after_create :if_deposit_payment_send_notification, :if => Proc.new{ self.payment_method == '3' }
  def if_deposit_payment_send_notification
    OrderMailer.notify(self).deliver
  end

  def the_id
    self.id.to_s.rjust(10,"0")
  end

  def the_total
    total + total_shipping - (total_discount ? total_discount : 0.0) + (credit_card_interest ? credit_card_interest : 0.0)
  end

  def self.build_for_checkout(user_id,items, delivery_method, delivery_user_address_id, payments = 1, payment_method = nil, payment_user_address_id = nil)
    
    order = Order.new
    
    user = User.find(user_id)
    order.user_id = user_id
    order.payments
    order.payment_method = payment_method

    user_address = (delivery_user_address_id.to_i != 0 ? UserAddress.find(delivery_user_address_id.to_i) : user.user_addresses.first)
    order.delivery_method = delivery_method
    order.delivery_address = "#{user_address.address} #{user_address.number}"
    order.delivery_complement = user_address.complement
    order.delivery_cep = user_address.cep
    order.delivery_city = user_address.city
    order.delivery_name = user_address.name
    order.delivery_neighbourhood = user_address.neighbourhood
    order.delivery_state = user_address.state

    if payment_user_address_id
      user_address = UserAddress.find(payment_user_address_id.to_i)
      order.payment_address = "#{user_address.address} #{user_address.number}"
      order.payment_complement = user_address.complement
      order.payment_cep = user_address.cep
      order.payment_city = user_address.city
      order.payment_name = user_address.name
      order.payment_neighbourhood = user_address.neighbourhood
      order.payment_state = user_address.state
    else
      order.payment_address = order.delivery_address
      order.payment_complement = order.delivery_complement
      order.payment_cep = order.delivery_cep
      order.payment_city = order.delivery_city
      order.payment_name = order.delivery_name
      order.payment_neighbourhood = order.delivery_neighbourhood
      order.payment_state = order.delivery_state
    end

    # calculate shipping
    shipping_options = ShippingCalculator.new(items).calculate_for_cep(user_address.cep)
    shipping_method = shipping_options.select{ |option| option.name == delivery_method }.first
    order.total_shipping = shipping_method.price
    order.delivery_days = shipping_method.days

    puts order.total_shipping

    total_products = 0.0
    items.each do |product_type_id,qty|
      product_type = ProductType.find(product_type_id)
      product = product_type.product
      if product_type
        order.order_items << OrderItem.new({
          order: order,
          product_id: product.id,
          qty: qty.to_i,
          product_type: product_type.name,
          product_name: product.name,
          product_subtitle: product.subtitle,
          price: product.price
        })
        total_products += product.price * qty.to_i
      end
    end
    order.total = total_products
    
    if order.payment_method == "1"
      order.credit_card_interest = PaymentCalculator.new(order.total + order.total_shipping).credit_card_total_interest(payments)
    elsif order.payment_method ==  "2"
      order.total_discount = ((order.total + order.total_shipping) * NutrisuporteSetting.boleto_discount / 100).round(2)
    elsif order.payment_method == "3"
      order.total_discount = ((order.total + order.total_shipping) * NutrisuporteSetting.debit_discount / 100).round(2)
    end

    order.check_items_availability
    return order
  end

end
