class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :user_type, :cpf, :phone, :mobile, :gender, :birth_date, :email_news, :user_addresses_attributes, :name
  attr_accessible :company_name, :cnpj, :state_registration
  validates_presence_of :name, :gender, :birth_date
  validates_presence_of :cpf, :if => Proc.new{ self.user_type == 'fisica' }
  validates_presence_of :cnpj, :company_name, :state_registration, :if => Proc.new{ self.user_type == 'juridica' }
  usar_como_cpf :cpf
  usar_como_cnpj :cnpj
  attr_accessor :importing
  validates :user_addresses, :length => { :minimum => 1 }, :unless => Proc.new{ |u| u.importing }
  has_many :user_addresses#, :dependent => :destroy
  accepts_nested_attributes_for :user_addresses, allow_destroy: true
  has_many :orders
  def the_gender
    {'m' => 'Masculino', 'f' => 'Feminino'}[self.gender]
  end
  # welcome e-mail
  after_create :send_welcome_email
  def send_welcome_email
    begin
      UserMailer.welcome(self).deliver unless self.importing
    rescue
      # --
    end
  end
end