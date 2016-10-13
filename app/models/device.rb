class Device < ActiveRecord::Base
  attr_accessible :community, :frequency, :ip, :name
  validates_presence_of :community, :frequency, :ip, :name
  validates_numericality_of :frequency, :greather_than => 1
end
