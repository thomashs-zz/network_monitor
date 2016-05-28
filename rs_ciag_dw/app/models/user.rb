class User < ActiveRecord::Base
  #
  # AUTH database
  #
  # establish_connection "user_#{Rails.env}".to_sym
  devise :database_authenticatable,
         :recoverable,
         :validatable,
         :lockable,
         :timeoutable,
         :maximum_attempts => 5,
         :lock_strategy => :failed_attempts,
         :unlock_strategy => :both,
         :unlock_in => 5.minutes,
         :timeout_in => 15.minutes
  #attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :user_type
end