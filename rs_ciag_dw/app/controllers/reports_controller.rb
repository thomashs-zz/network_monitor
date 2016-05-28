# encoding: UTF-8
class ReportsController < ApplicationController

	def index
		@reports = Report.order(:relevance)
	end

	def new
		@report = Report.new
	end

	def create
		@report = Report.new(report_params)
		if @report.save
			redirect_to report_path(@report), notice: 'Relatório criado com sucesso.'
		else
			render action: :new
		end
	end

	def show
		@report = Report.find(params[:id])
	end

	def edit
		@report = Report.find(params[:id])
	end

	def update
		@report = Report.find(params[:id])
		if @report.update_attributes(report_params)
			redirect_to report_path(@report), notice: 'Relatório atualizado com sucesso.'
		else
			render action: :edit
		end
	end

	def destroy
		@report = Report.find(params[:id])
		@report.destroy
		redirect_to reports_path, notice: 'Relatório removido com sucesso'
	end

	private 

	def report_params
		params.require(:report).permit!
	end

end