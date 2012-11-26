class FeaturesController < ApplicationController

  layout :get_layout
  
  def create_scenario_results(hits)
    results = Array.new 
    hits.each do | feature_scenario |
        name = feature_scenario.stored(:name).first        
        tag_ids = feature_scenario.stored(:tag_ids)
        highlights = feature_scenario.highlights(:name)
        highlight = highlights.first if highlights.any?        
        results << ScenarioSearchResult.new(:name => name, 
          :id => feature_scenario.primary_key, :highlight => highlight, :tag_ids => tag_ids)
    end
    return results
  end

  def create_search_results (raw_results)
    results = Array.new 
    raw_results.each do | feature_scenarios |
      feature_name = feature_scenarios.hits.first.stored(:feature_name).first                
      slug = feature_scenarios.hits.first.stored(:feature_slug)      
      id =feature_scenarios.value
      feature = FeatureSearchResult.new(:name => feature_name, :id => id, 
        :show_more => feature_scenarios.hits.count > 5, :slug => slug)    
      scenarios = create_scenario_results(feature_scenarios.hits.take(5))
      feature.scenarios =scenarios      
      results<<feature
    end

    return results

  end

  # GET /features
  # GET /features.json
  def index

    @features = Array.new 
    @tag_results = Array.new
    @active_tags = Array.new

    if params[:query].to_s.empty? and params[:tags].to_s.empty?
      @tag_results=Scenario.tag_counts_on(:tags)
    else 
    search = Scenario.search do
      group(:feature_id_str) do
        limit 6
      end
      
      unless params[:query].to_s.empty?          
        fulltext params[:query].to_s do
          highlight :name
          minimum_match 1
        end   
      end 
      
      facet :tag_ids             

      if params["tags"]
        with(:tag_ids, params["tags"])
      end      
    end 


    active_tag_ids = Array.new
    active_tag_ids = params["tags"].map { |tag_id| tag_id.to_i } if params["tags"]

    tag_ids = search.facet(:tag_ids).rows.map { |row| row.value } | active_tag_ids
    tags = ActsAsTaggableOn::Tag.find(tag_ids)  
    tags_by_id = Hash[tags.map { |t| [t.id, t] }]

    @features = create_search_results(search.groups[0].groups)


    @tag_results = search.facet(:tag_ids).rows.map { |row| TagResult.new(:id => row.value, 
      :name => tags_by_id[row.value], :count => row.count) }

    @active_tags = active_tag_ids.map { |tag_id| tags_by_id[tag_id] }

    if params["tags"]
      @tag_results = @tag_results.reject { |e| params["tags"].include?(e.id.to_s) }
    end
    
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
    feature_id = @feature.id
    @active_tags=Array.new
    
    if params[:tags]
        tags = ActsAsTaggableOn::Tag.find(params[:tags].map { |tag| tag.to_i  })  
        @active_tags= tags
    end 
      
    search = Scenario.search do        
      with(:feature_id_str, feature_id)
      
      unless params[:query].to_s.empty?          
        fulltext params[:query].to_s do
          highlight :name
          minimum_match 1
        end   
      end 
      
      paginate :page => 1, :per_page => 500

      facet :tag_ids             

      if params["tags"]
        with(:tag_ids, params["tags"])
      end          
    end 
    @scenarios = create_scenario_results(search.hits)

    tags = ActsAsTaggableOn::Tag.all
    tags_by_id = Hash[tags.map { |t| [t.id, t] }]
    @tag_results = search.facet(:tag_ids).rows.map { |row| TagResult.new(:id => row.value, 
      :name => tags_by_id[row.value], :count => row.count) }    

    if params["tags"]
      @tag_results = @tag_results.reject { |e| params["tags"].include?(e.id.to_s) }
    end
    
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
