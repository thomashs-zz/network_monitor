class Report < ActiveRecord::Base
	has_many :report_queries, dependent: :destroy
	accepts_nested_attributes_for :report_queries, :allow_destroy => true
	validates_presence_of :name, :relevance
end
