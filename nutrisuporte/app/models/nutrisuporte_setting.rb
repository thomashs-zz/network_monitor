class NutrisuporteSetting < ActiveRecord::Base
  attr_accessible :banner_home_image, :banner_home_image_cache, :boleto_discount, :credit_card_interest, :credit_card_max_payments, :debit_discount, :show_banner_home, :minimum_size_payment, :max_payments, :cep_origem, :motoboy_available, :correios_cod_empresa, :correios_senha, :main_phone, :email, :address, :open_time, :terms_of_use, :about_page, :max_weight, :get_on_store_available, :get_on_store_message, :max_payments_display
  validates_presence_of :boleto_discount, :credit_card_interest, :credit_card_max_payments, :debit_discount, :max_payments, :minimum_size_payment
  validates_presence_of :banner_home_image, :if => Proc.new { self.show_banner_home }
  #validates_presence_of :motoboy_price_per_km, :if => Proc.new{ self.motoboy_available }
  mount_uploader :banner_home_image, BannerHomeUploader
  def to_s
  	"Configuração"
  end
  def self.method_missing(name)
    cache = ActiveSupport::Cache::MemoryStore.new
    if cache.exist?(name)
      cache.read(name)
    else
  	  val = NutrisuporteSetting.first.send(name)
      cache.write(name,val)
      val
    end
  end
  before_save :update_cache
  def update_cache
    cache = ActiveSupport::Cache::MemoryStore.new
    self.attributes.each do |att,val|
      cache.write(att,val)
    end
  end

  def self.parcelamentos
    parcelamentos = []
    #if NutrisuporteSetting.credit_card_max_payments > 1
    #  parcelamentos << { 
    #    :minimo => 1, 
    #    :maximo => NutrisuporteSetting.credit_card_max_payments,
    #    :repassar => false,
    #    :juros => 0.0,
    #  }
    #  parcelamentos << { 
    #    :minimo => NutrisuporteSetting.credit_card_max_payments + 1,
    #    :maximo => NutrisuporteSetting.max_payments, 
    #    :repassar => true,
    #    :juros => 0.0
    #  }
    #else
      parcelamentos << { 
        :minimo => 1, 
        :maximo => NutrisuporteSetting.max_payments, 
        :repassar => false,
        :juros => 0.0 
      }
    #end
    parcelamentos
  end

end
