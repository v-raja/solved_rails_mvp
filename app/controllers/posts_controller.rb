class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:upvote, :remove_upvote]
  before_action :set_post, only: [:show, :edit, :update, :destroy, :upvote,
                                  :remove_upvote]

  before_action :set_niche, only: [:niche_index]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  def niche_index
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

  def preview_industries
    niches_str = params[:niches]
    @niches = IndustryCategory.get_industries_from_string(niches_str)
    respond_to do |format|
      format.js
    end
  end

  def preview_occupations
    niches_str = params[:niches]
    @niches = OccupationCategory.get_occupations_from_string(niches_str)
    respond_to do |format|
      format.js
    end
  end


  # GET /posts/1/edit
  def edit
  end

  # GET /posts/new
  def new
    @post = Post.new

    @post.youtube_urls.build
    @post.build_product
  end

  # POST /posts
  # POST /posts.json
  def create
    # byebug
    # p tags_string_param
    @post = current_user.posts.build(post_params)

    if post_params[:product_id].blank?
      @post.build_product(product_params)
    end

    respond_to do |format|
      if @post.save
        industries = IndustryCategory.get_industries_from_string(params[:post][:industries_string])
        industries.each do |industry|
          @post.post_to_industry(industry)
        end

        occupations = OccupationCategory.get_occupations_from_string(params[:post][:occupations_string])
        occupations.each do |occupation|
          @post.post_to_occupation(occupation)
        end

        # first_comment = Comment.build_from(@post, current_user, params[:comment_text])
        # first_comment.create

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
      params.require(:post).permit(:problem_title, :description, :product_id, :product_url, product_attributes: [:name, :logo_url], youtube_urls_attributes: [:_destroy, :id, :url])
    end

    def extra_params
      params.require(:post).permit(:tags_string, :industries_string, :occupations_string, :comment_text)
    end

    def product_params
      params.require(:post).require(:product_attributes).permit(:name, :logo_url)
    end

    def set_niche
      if params[:industry_id]
        @niche = Industry.friendly.find params[:industry_id]
      else
        @niche = Occupation.friendly.find params[:occupation_id]
      end

      # If an old id or a numeric id was used to find the record, then
      # the request path will not match the post_path, and we should do
      # a 301 redirect that uses the current friendly id.
      # if params[:id] != @niche.slug
      #   return redirect_to @industry, :status => :moved_permanently
      # end
    end
end
