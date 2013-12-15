class LogsController < ApplicationController
	skip_before_filter :log
	def index
		@logs=Log.all.order("created_at DESC")
	end
end