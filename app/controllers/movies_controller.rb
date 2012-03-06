class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
      @all_ratings = ['G','PG','PG-13','R']
      ratings = params[:ratings]
      @saved_rating = {}
     if ratings==nil
       keys=@all_ratings
       @saved_rating = {}
       else
         keys=ratings.keys
         ratings.each {|key,value| @saved_rating["ratings[" + key +"]"] = 1 }

     end
      @checked = {}
      @all_ratings.each { |rate| keys.index(rate) ? @checked[rate] = true : @checked[rate] = false}
      sort = params[:order]
      @sort = sort  unless sort == nil
      @title_class = ""
      @release_class = ""
      if @sort == "title"
        @title_class = "hilite"
      elsif @sort == "release_date"
        @release_class = "hilite"
      end
      @movies = Movie.find(:all,:order =>@sort, :conditions => [ "rating IN (?)", keys])
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
