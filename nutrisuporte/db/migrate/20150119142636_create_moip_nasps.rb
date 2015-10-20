class CreateMoipNasps < ActiveRecord::Migration
  def change
    create_table :moip_nasps do |t|
      t.integer :id_transacao
      t.decimal :valor
      t.integer :status_pagamento
      t.string :cod_moip
      t.string :forma_pagamento
      t.string :tipo_pagamento
      t.integer :parcelas
      t.string :email_consumidor
      t.string :recebedor_login
      t.string :cartao_bin
      t.string :cartao_final
      t.string :cartao_bandeira
      t.string :cofre
      t.string :classificacao
      t.timestamps
    end
  end
end