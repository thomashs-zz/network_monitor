class CreateNutrisuporteSettings < ActiveRecord::Migration
  def up
    create_table :nutrisuporte_settings do |t|
      t.string :banner_home_image
      t.integer :boleto_discount
      t.integer :debit_discount
      t.decimal :credit_card_interest
      t.integer :credit_card_max_payments
      t.boolean :show_banner_home
      t.decimal :minimum_size_payment
      t.integer :max_payments
      t.string :cep_origem
      t.boolean :motoboy_available
      t.decimal :motoboy_price_per_km
      t.integer :motoboy_max_distance
      t.string :correios_cod_empresa
      t.string :correios_senha
      t.timestamps 
    end
    NutrisuporteSetting.create! :boleto_discount => 5, 
                                :debit_discount => 5, 
                                :credit_card_interest => 1.99, 
                                :credit_card_max_payments => 5,
                                :show_banner_home => false,
                                :minimum_size_payment => 1.00,
                                :max_payments => 12,
                                :cep_origem => "90550-031",
                                :motoboy_available => false
  end
  def down
    drop_table :nutrisuporte_settings
  end
end
