class SolutionsController < ApplicationController
  before_action :set_solution, only: [:show, :edit, :update, :destroy, :upvote,
                                      :remove_upvote, :follow, :unfollow]

  before_action :set_niche,    only: [:niche_index]
  etag { current_user.try :id }

  def niche_index
    set_meta_tags title: "The best new solutions for #{@niche.title}",
                  description: "The best new solutions for #{@niche.keywords}",
                  keywords: @niche.keyword_list,
                  reverse: true,
                  canonical: polymorphic_url(@niche)
    if params[:tag]
      # NOTE: the adding below changes @solutions to an array and so scopes like .today
      # don't work. Currently, we just check if param is used, and if so, don't use logic
      # that uses scopes like today in the view.
      @solutions = @niche.solutions.tagged_with(params[:tag], on: :general_tags) + @niche.solutions.tagged_with(params[:tag], on: :niche_specific_tags)
      @solutions.uniq!
    else
      @solutions = @niche.solutions
    end
  end

  def follow
    authorize @solution
    current_user.follow(@solution)
    redirect_to @solution
  end

  def unfollow
    authorize @solution
    current_user.stop_following(@solution)
    redirect_to @solution
  end

  def upvote
    authorize @solution
    respond_to do |format|
      if !current_user.voted_for? @solution
        @solution.liked_by current_user
        format.html { redirect_to @solution }
        format.js
      else
        format.html { redirect_to @solution, notice: "You've already upvoted the solution." }
      end
    end
  end

  def remove_upvote
    authorize @solution
    respond_to do |format|
      if current_user.voted_for? @solution
        @solution.unliked_by current_user
        format.html { redirect_to @solution }
        format.js
      else
        format.html { redirect_to @solution, notice: "You haven't voted for the solution." }
      end
    end
  end

  # GET /solutions/1
  # GET /solutions/1.json
  def show
    fresh_when @solution
    set_meta_tags title: @solution.title,
                  description: @solution.description,
                  reverse: true,
                  canonical: solution_url(@solution)
    if user_signed_in?
      @new_comment = Comment.build_from(@solution, current_user, "")
    end
  end


  # GET /solutions/1/edit
  def edit
    set_meta_tags noindex: true
    authorize @solution
  end

  # GET /solutions/new
  def new
    set_meta_tags noindex: true
    @solution = Solution.new
    authorize @solution
    @solution.youtube_urls.build
    @solution.build_product
    @solution.comment_threads.build
    @solution.user = current_user
  end

  # POST /solutions
  # POST /solutions.json
  def create
    authorize Solution
    @solution = current_user.solutions.build(solution_params)

    if solution_params[:product_id].blank?
      @solution.build_product(product_params)
    end

    respond_to do |format|
      if @solution.save

        current_user.follow(@solution)
        @solution.niche_list.each do |n|
          current_user.follow(n)
        end

        format.html { redirect_to @solution, notice: {title: 'Solution was successfully created.', body: "You're now following the niches you posted to." }}
        format.json { render :show, status: :created, location: @solution }
      else
        format.html { render :new }
        format.json { render json: @solution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /solutions/1
  # PATCH/PUT /solutions/1.json
  def update
    authorize @solution
    respond_to do |format|
      if @solution.update(solution_params)

        current_user.follow(@solution)
        @solution.niche_list.each do |n|
          current_user.follow(n)
        end
        format.html { redirect_to @solution, notice: 'Solution was successfully updated.' }
        format.json { render :show, status: :ok, location: @solution }
      else
        format.html { render :edit }
        format.json { render json: @solution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /solutions/1
  # DELETE /solutions/1.json
  def destroy
    authorize @solution
    @solution.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Solution was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_solution
      @solution = Solution.friendly.find(params[:id])

      if params[:id] != @solution.slug
        return redirect_to @solution, :status => :moved_permanently
      end
    end

    # Only allow a list of trusted parameters through.
    def solution_params
      params.require(:solution).permit(:title, :description, :product_id, :get_it_url, comment_threads_attributes: [:user_id, :body],
            general_tag_list: [], niche_specific_tag_list: [], niche_list: [], product_attributes: [:name, :thumbnail_url], youtube_urls_attributes: [:_destroy, :id, :url])
    end

    def product_params
      params.require(:solution).require(:product_attributes).permit(:name, :thumbnail_url)
    end

    def set_niche
      if params[:industry_id]
        @niche = Industry.friendly.find params[:industry_id]
      else
        @niche = Occupation.friendly.find params[:occupation_id]
      end

      # If an old id or a numeric id was used to find the record, then
      # the request path will not match the solution_path, and we should do
      # a 301 redirect that uses the current friendly id.
      id = params[:industry_id] || params[:occupation_id]
      if id != @niche.slug
        return redirect_to @niche, :status => :moved_permanently
      end

    end
end
