class SolutionsController < ApplicationController
  before_action :set_solution, only: [:show, :edit, :update, :destroy, :upvote,
                                      :remove_upvote]

  before_action :set_niche,    only: [:niche_index]

  def niche_index
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
    if user_signed_in?
      @new_comment = Comment.build_from(@solution, current_user, "")
    end
  end


  # GET /solutions/1/edit
  def edit
    authorize @solution
  end

  # GET /solutions/new
  def new
    @solution = Solution.new
    authorize @solution

    @solution.youtube_urls.build
    @solution.build_product
  end

  # POST /solutions
  # POST /solutions.json
  def create
    authorize Solution
    @solution = current_user.solutions.build(solution_params)

    if solution_params[:product_id].blank?
      @solution.build_product(product_params)
    end

    @solution.tag_list.add(params[:tags_string], parse: true)

    respond_to do |format|
      if @solution.save

        # first_comment = Comment.build_from(@solution, current_user, params[:comment_text])
        # first_comment.create

        format.html { redirect_to @solution, notice: 'Solution was successfully created.' }
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
    end

    # Only allow a list of trusted parameters through.
    def solution_params
      params.require(:solution).permit(:title, :description, :product_id, :get_it_url, niche_list: [], product_attributes: [:name, :thumbnail_url], youtube_urls_attributes: [:_destroy, :id, :url])
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
