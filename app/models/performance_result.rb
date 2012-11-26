class PerformanceResult < ActiveRecord::Base
	attr_accessible :build_version, :time
	belongs_to :scenario, :inverse_of => :performance_results
end
