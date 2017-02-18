class MoviesController < ApplicationController
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings.sort
    
    if params.key?(:ratings)
      puts params[:ratings]
      session[:ratings] = params[:ratings]
      @filter_ratings = params[:ratings]
      @movies = Movie.order(params[:sort]).where(:rating => @filter_ratings.keys)
    elsif session.key?(:ratings)
      params[:ratings] = session[:ratings]
      flash.keep
      redirect_to movies_path(params) and return
    else 
      @filter_ratings = @all_ratings
      params[:ratings] = session[:ratings] = @all_ratings
      @movies = Movie.order(params[:sort]).all
    end
    
    if params[:sort] == 'title'
      session[:sort] = params[:sort]
      @title_header = 'hilite'
    elsif params[:sort] == 'release_date'
      session[:sort] = params[:sort]
      @release_date_header = 'hilite'
    elsif session.key?(:sort)
      params[:sort] = session[:sort]
      flash.keep
      redirect_to movies_path(params) and return
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
