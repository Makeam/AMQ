class SearchController < ApplicationController

  def index
    @results = Question.search(params[:search][:query])
  end

end
