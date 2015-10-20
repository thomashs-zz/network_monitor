# encoding: UTF-8
ActiveAdmin.register NutrisuporteSetting do

  menu parent: "Configurações"

	form do |f|
		f.inputs "Configurações" do
			f.input :banner_home_image, :as => :file, :hint => (f.template.image_tag(f.object.banner_home_image.url(:thumb)) if f.object.banner_home_image?) 
      f.input :banner_home_image_cache, :as => :hidden, :wrapper_html => { :style => "display:none;" }
      f.input :show_banner_home, as: :boolean
      f.input :credit_card_interest, as: :number, hint: "Somente números, referente a % de juros ao mês"
      f.input :credit_card_max_payments, as: :number, hint: "Quantidade máxima de parcelas que não cobram juros"
      f.input :boleto_discount, as: :number, hint: "Somente números"
      f.input :debit_discount, as: :number, hint: "Somente números"
      f.input :max_payments, as: :number, hint: "Somente números"
      f.input :max_payments_display, as: :number, hint: "Somente números"
      f.input :minimum_size_payment, as: :number, hint: "Somente números"
      f.input :cep_origem, hint: "formato: 00000-000"
      f.input :motoboy_available, as: :boolean
      #f.input :motoboy_price_per_km, as: :number, hint: "Separe as casas decimais com um ponto"
      #f.input :motoboy_max_distance, as: :number
      f.input :get_on_store_available, as: :boolean
      f.input :get_on_store_message
      f.input :correios_cod_empresa
      f.input :correios_senha
      f.input :max_weight, as: :number, hint: "Peso (em gramas) máximo das compras"
		end
    f.inputs "CMS" do
      f.input :main_phone
      f.input :email
      f.input :address
      f.input :open_time
      f.input :terms_of_use, as: :wysihtml5, blocks: [:h1,:h2,:h3,:h4,:p]
      f.input :about_page, as: :wysihtml5, blocks: [:h1,:h2,:h3,:h4,:p]
    end
		f.actions
	end

	controller do
    def redirect_to_edit
      redirect_to edit_admin_nutrisuporte_setting_path(NutrisuporteSetting.first), :flash => flash
    end
    alias_method :index, :redirect_to_edit
    alias_method :show,  :redirect_to_edit
    alias_method :new, :redirect_to_edit
  end

end