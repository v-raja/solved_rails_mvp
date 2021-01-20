class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy, :upvote,
                                     :remove_upvote]
  before_action :set_niche,   only: [:niche_index]


  def niche_index
  end

  def upvote
    authorize @request
    respond_to do |format|
      if !current_user.voted_for? @request
        @request.liked_by current_user
        format.html { redirect_to @solution }
        format.js
      else
        format.html { redirect_to @request, notice: "You've already upvoted the request." }
      end
    end
  end

  def remove_upvote
    authorize @request
    respond_to do |format|
      if current_user.voted_for? @request
        @request.unliked_by current_user
        format.html { redirect_to @solution }
        format.js
      else
        format.html { redirect_to @request, notice: "You haven't voted for the request." }
      end
    end
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
    if user_signed_in?
      @new_comment = Comment.build_from(@request, current_user, "")
    end
  end


  # GET /requests/1/edit
  def edit
    authorize @request
  end

  # GET /requests/new
  def new
    @request = Request.new
    authorize @request
  end

  # POST /requests
  # POST /requests.json
  def create
    authorize Request
    @request = current_user.requests.build(request_params)

    respond_to do |format|
      if @request.save
        format.html { redirect_to @request, notice: 'Request was successfully created.' }
        format.json { render :show, status: :created, location: @request }
      else
        format.html { render :new }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requests/1
  # PATCH/PUT /requests/1.json
  def update
    authorize @request
    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to @request, notice: 'Request was successfully updated.' }
        format.json { render :show, status: :ok, location: @request }
      else
        format.html { render :edit }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    authorize @request
    @request.destroy
    respond_to do |format|
      format.html { redirect_to requests_url, notice: 'Request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def request_params
      params.require(:request).permit(:title, :description, niche_list: [])
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
      # if params[:id] != @niche.slug
      #   return redirect_to @industry, :status => :moved_permanently
      # end
    end
end
