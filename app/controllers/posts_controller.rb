class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show, :search]
    
  def search
    if params[:search].present?
      @posts = Post.search(params[:search])
    else
      @posts = Post.all
    end
  end
  # GET /posts
  # GET /posts.json
  def index
    prepare_meta_tags title: "Blog", description: "Keep up to date with FlyAnima's recent news and updates"
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    prepare_meta_tags(title: @post.title,
                      description: @post.body,

                      #image: @post.picture.url(:large),
                      twitter: {card: "summary_large_image"})  
                      @page_keywords    = @post.keywords
      
    @reviews = Review.where(post_id: @post.id).order("created_at DESC")
    @users = User.all
      
    if @reviews.blank?
      @avg_review = 0
    else 
      @avg_review = @reviews.average(:rating).round(2)    
    end
      
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, :category, :keywords, :image)
    end
    
end
