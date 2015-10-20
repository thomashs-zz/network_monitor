class PaymentCalculator
	
	attr_accessor :total
	
	def initialize(total)
		self.total = total
	end
	
	def max_installments
    i = 1
    default_payment_size = NutrisuporteSetting.first.minimum_size_payment
    max_payments = NutrisuporteSetting.max_payments
    return 1 if self.total <= default_payment_size
    while installment_price(i) >= default_payment_size and i <= max_payments
      i += 1 
    end
    return i - 1
	end

	def installment_price(i)
    i = i.to_i
		if i > NutrisuporteSetting.credit_card_max_payments
      rounded_payment((self.total * (1 + NutrisuporteSetting.credit_card_interest / 100) ** i),i)
    else
      rounded_payment(self.total,i)
    end
	end

  def credit_card_price(i)
    i = i.to_i
    installment_price(i) * i
  end

  def credit_card_total_interest(i)
    i = i.to_i
    if i > NutrisuporteSetting.credit_card_max_payments
      credit_card_price(i) - self.total
    else
      0.0
    end
  end

  def boleto_price
    if NutrisuporteSetting.boleto_discount > 0
      (self.total - (self.total * NutrisuporteSetting.boleto_discount / 100)).round(2)
    else
      self.total
    end
  end

  def deposit_price
    if NutrisuporteSetting.debit_discount > 0
      (self.total - (self.total * NutrisuporteSetting.debit_discount / 100)).round(2)
    else
      self.total
    end
  end
	
	private
  def rounded_payment(value,x)
    pp = (value / x).round(2)
    pp = self.total - pp * x > 0 ? pp + 0.01 : pp
  end

end