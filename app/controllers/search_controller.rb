class SearchController < ApplicationController

  def index
    @results = Finder.search params[:search][:query], params[:search][:filter]
    respond_with( @results )
  end

end
