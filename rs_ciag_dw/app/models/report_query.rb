require 'bigdecimal'

module Mondrian
  module OLAP
    class Result
      
      def to_html(options = {})
        case axes_count
        when 1
          builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |doc|
            doc.table id: "data-table-#{options[:id]}", "data-id" => options[:id], 'chart-type' => options[:chart_type] do
              doc.tr do
                column_full_names.each do |column_full_name|
                  column_full_name = column_full_name.join(',') if column_full_name.is_a?(Array)
                  doc.th column_full_name, :align => 'right'
                end
              end
              doc.tr do
                (options[:formatted] ? formatted_values : values).each do |value|
                  doc.td value, :align => 'right'
                end
              end
            end
          end
          builder.doc.to_html
        when 2
          builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |doc|
            doc.table id: "data-table-#{options[:id]}", 'data-id' => options[:id], 'chart-type' => options[:chart_type] do
              doc.tr do
                doc.th
                column_full_names.each do |column_full_name|
                  column_full_name = column_full_name.join(',') if column_full_name.is_a?(Array)
                  doc.th column_full_name, :align => 'right'
                end
              end
              (options[:formatted] ? formatted_values : values).each_with_index do |row, i|
                doc.tr do
                  row_full_name = row_full_names[i].is_a?(Array) ? row_full_names[i].join(',') : row_full_names[i]
                  doc.th row_full_name, :align => 'left'
                  row.each do |cell|
                    doc.td cell, :align => 'right'
                  end
                end
              end
            end
          end
          builder.doc.to_html
        else
          raise ArgumentError, "just columns and rows axes are supported"
        end
      end   
    
    end
  end
end

class ReportQuery < ActiveRecord::Base
  belongs_to :report
  @@report_types = ['somente_tabela','line', 'spline', 'area', 'areaspline', 'column', 'bar', 'pie', 'scatter', 'gauge', 'arearange', 'areasplinerange', 'columnrange']
  default_scope lambda{ order(:relevance) }
  cattr_accessor :report_types
  validates_inclusion_of :report_type, in: @@report_types
  validates_presence_of :title, :subtitle, :relevance, :report_type, :query

  def get_html_table
    begin 
      Dwh.olap.execute(query).to_html(formatted_values: true, id: "#{id}", chart_type: report_type)
    rescue
      "Nao foi possivel executar esta query."
    end
  end

end
