class ScenariosController < ApplicationController
	layout :get_layout
	def show
		@scenario = Scenario.find(params[:id])    
	end
end
