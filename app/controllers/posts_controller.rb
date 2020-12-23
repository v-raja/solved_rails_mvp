class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:upvote, :remove_upvote]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :upvote,
                                  :remove_upvote]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  def upvote
    @post.liked_by current_user
    respond_to do |format|
      format.js
    end
  end

  def remove_upvote
    @post.unliked_by current_user
    respond_to do |format|
      format.js
    end
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    if user_signed_in?
      @new_comment = Comment.build_from(@post, current_user, "")
    end
  end

  # GET /posts/new
  def new
    @post = Post.new
    @post.youtube_urls.build
  end

  def preview_industries
    niches_str = params[:niches]
    @niches = []
    niches_str.split(", ").each do |niche_code|
      if niche_code.length == 6 then
        @niches.concat Industry.where(id: niche_code)
      else
        @niches.concat IndustryCategory.get_industries(niche_code)
      end
    end
    @niches.uniq!
    respond_to do |format|
      format.js
    end
  end

  def preview_occupations
    niches_str = params[:niches]
    @niches = []
    niches_str.split(", ").each do |niche_code|
      p niche_code
      if niche_code[-1] != '0' then
        @niches.concat Occupation.where(code: niche_code)
      else
        @niches.concat OccupationCategory.get_occupations(niche_code)
      end
    end
    @niches.uniq!
    # p @niches
    respond_to do |format|
      format.js
    end
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

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:problem_title, :tagline, :description, :youtube_url, :product_url)
    end
end
