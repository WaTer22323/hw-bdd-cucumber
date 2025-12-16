###########################
class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]

  # GET /movies or /movies.json
  def index
    @all_ratings = Movie.all_ratings

    # --- ส่วนที่ 1: จัดการ ratings (Filter) ---
    if params[:ratings]
      @ratings_to_show = params[:ratings]
      
      # FIX: เช็คก่อนว่าตัวแปรนี้มีคำสั่ง permit! ให้เรียกไหม (ถ้าเป็น Array จะข้ามไป ไม่ error)
      if @ratings_to_show.respond_to?(:permit!)
        @ratings_to_show = @ratings_to_show.permit!
      end

      # ถ้าเป็น Hash (มาจาก Form) ให้ดึง Keys, ถ้าเป็น Array (มาจาก Link) ให้ใช้ค่าเดิม
      if @ratings_to_show.respond_to?(:keys)
        @ratings_to_show = @ratings_to_show.keys
      end
      
      session[:ratings] = @ratings_to_show
    elsif session[:ratings]
      @ratings_to_show = session[:ratings]
    else
      @ratings_to_show = @all_ratings
    end

    # --- ส่วนที่ 2: จัดการ sort ---
    if params[:sort]
      @sort = params[:sort]
      session[:sort] = @sort
    elsif session[:sort]
      @sort = session[:sort]
    end

    # --- ส่วนที่ 3: Redirect เพื่อรักษา State ---
    if params[:sort] != session[:sort] || params[:ratings] != session[:ratings]
      flash.keep
      redirect_to movies_path(sort: session[:sort], ratings: session[:ratings]) and return
    end

    # --- ส่วนที่ 4: Query ---
    @movies = Movie.where(rating: @ratings_to_show)
    
    if @sort
      @movies = @movies.order(@sort)
    end
  end

  # GET /movies/1 or /movies/1.json
  def show
  end

  # GET /movies/new
  def new
    @movie = Movie.new
  end

  # GET /movies/1/edit
  def edit
  end

  # POST /movies or /movies.json
  def create
    @movie = Movie.new(movie_params)

    respond_to do |format|
      if @movie.save
        format.html { redirect_to @movie, notice: "Movie was successfully created." }
        format.json { render :show, status: :created, location: @movie }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /movies/1 or /movies/1.json
  def update
    respond_to do |format|
      if @movie.update(movie_params)
        format.html { redirect_to @movie, notice: "Movie was successfully updated." }
        format.json { render :show, status: :ok, location: @movie }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @movie.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /movies/1 or /movies/1.json
  def destroy
    @movie.destroy!

    respond_to do |format|
      format.html { redirect_to movies_path, status: :see_other, notice: "Movie was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Movie.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
end