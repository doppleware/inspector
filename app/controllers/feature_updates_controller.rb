class FeatureUpdatesController < ApplicationController
  respond_to :json

  def create
  	processing = 0
  	
  	existing_features = Feature.includes(:scenarios).all.group_by { |feature| feature.name }

  	params[:features].each { |feature|
  		existing_feature = existing_features[feature["Name"]]
  		if existing_feature  			
  			feature["Scenarios"].each { |scenario|
  				existing_scenario = existing_feature.first.scenarios.find { |s| s.name == scenario["Name"] }
  				unless existing_scenario
  					existing_feature.first.scenarios << Scenario.new(:name => scenario["Name"])
  				end
  			}

  			scenarioNames = feature["Scenarios"].collect { |s| s["Name"]}.to_a
  			scenariosToDelete = existing_feature.first.scenarios.reject { |s| scenarioNames.include? s.name}
			  scenariosToDelete.each { |scenario|	scenario.delete!	}

  		else
  			Feature.create!(:name => feature["Name"])
  		end
  	}  	





  	render :json => "we good!" + processing.to_s, :status => :ok
  end
end
