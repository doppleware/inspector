class FeaturesController < ApplicationController
  
  def create_search_results (raw_results)
    
    results = Array.new 
    raw_results.each do | feature_scenarios |
      feature_name = feature_scenarios.hits.first.stored(:feature_name).first
      id =feature_scenarios.value
      feature = FeatureSearchResult.new(:name => feature_name, :id => id)
      feature_scenarios.hits.each do | feature_scenario |

        name = feature_scenario.stored(:name).first        
        highlights = feature_scenario.highlights(:name)
        highlight = highlights.first if highlights.any?        
        feature.scenarios << ScenarioSearchResult.new(:name => name, 
          :id => feature_scenario.primary_key, :highlight => highlight)
      end 
      results<<feature
    end

    return results
  
  end

  # GET /features
  # GET /features.json
  def index

    unless params[:query].to_s.empty?
      search = Scenario.search do
        group(:feature_id_str) do
          limit 5
        end
        fulltext params[:query].to_s do
          highlight :name
        end         
      end 
      @features = create_search_results(search.groups[0].groups)
    end
    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @features }
      format.js
    end
  end

  # GET /features/1
  # GET /features/1.json
  def show
    @feature = Feature.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feature }
      format.js
    end
  end

  # GET /features/new
  # GET /features/new.json
  def new
    @feature = Feature.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feature }
    end
  end

  # GET /features/1/edit
  def edit
    @feature = Feature.find(params[:id])
  end

  # POST /features
  # POST /features.json
  def create
    @feature = Feature.new(params[:feature])

    respond_to do |format|
      if @feature.save
        format.html { redirect_to @feature, notice: 'Feature was successfully created.' }
        format.json { render json: @feature, status: :created, location: @feature }
      else
        format.html { render action: "new" }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /features/1
  # PUT /features/1.json
  def update
    @feature = Feature.find(params[:id])

    respond_to do |format|
      if @feature.update_attributes(params[:feature])
        format.html { redirect_to @feature, notice: 'Feature was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feature.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /features/1
  # DELETE /features/1.json
  def destroy
    @feature = Feature.find(params[:id])
    @feature.destroy

    respond_to do |format|
      format.html { redirect_to features_url }
      format.json { head :no_content }
    end
  end
end
