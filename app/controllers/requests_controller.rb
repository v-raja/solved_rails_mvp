class RequestsController < ApplicationController
  before_action :authenticate_user!, only: [:upvote, :remove_upvote]
  before_action :set_request, only: [:show, :edit, :update, :destroy, :upvote,
                                  :remove_upvote]
  before_action :set_niche, only: [:index]

  # GET /requests
  # GET /requests.json
  def index
    @requests = Request.all
  end

  def upvote
    @request.liked_by current_user
    respond_to do |format|
      format.js
    end
  end

  def remove_upvote
    @request.unliked_by current_user
    respond_to do |format|
      format.js
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
  end

  # GET /requests/new
  def new
    @request = Request.new
  end

  # POST /requests
  # POST /requests.json
  def create
    # byebug
    @request = current_user.requests.build(request_params)

    respond_to do |format|
      if @request.save
        industries = IndustryCategory.get_industries_from_string(params[:request][:industries_string])
        industries.each do |industry|
          @request.post_to_industry(industry)
        end

        occupations = OccupationCategory.get_occupations_from_string(params[:request][:occupations_string])
        occupations.each do |occupation|
          @request.post_to_occupation(occupation)
        end

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
    @request.destroy
    respond_to do |format|
      format.html { redirect_to requests_url, notice: 'Request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def request_params
      params.require(:request).permit(:title, :description)
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
