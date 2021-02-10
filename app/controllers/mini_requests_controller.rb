class MiniRequestsController < ApplicationController
  before_action :set_mini_request, only: [:show, :edit, :update, :destroy]

  # GET /mini_requests
  # GET /mini_requests.json
  def index
    @mini_requests = MiniRequest.all
  end

  # GET /mini_requests/1
  # GET /mini_requests/1.json
  def show
  end

  # GET /mini_requests/new
  def new
    @mini_request = MiniRequest.new
  end

  # GET /mini_requests/1/edit
  def edit
  end

  # POST /mini_requests
  # POST /mini_requests.json
  def create
    @mini_request = MiniRequest.new(mini_request_params)
    authorize @mini_request
    if user_signed_in?
      @mini_request.user = current_user
    end
    respond_to do |format|
      if @mini_request.save
        format.js
      else
        format.js
      end
    end
  end

  # PATCH/PUT /mini_requests/1
  # PATCH/PUT /mini_requests/1.json
  def update
    respond_to do |format|
      if @mini_request.update(mini_request_params)
        format.html { redirect_to @mini_request, notice: 'Mini request was successfully updated.' }
        format.json { render :show, status: :ok, location: @mini_request }
      else
        format.html { render :edit }
        format.json { render json: @mini_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mini_requests/1
  # DELETE /mini_requests/1.json
  def destroy
    @mini_request.destroy
    respond_to do |format|
      format.html { redirect_to mini_requests_url, notice: 'Mini request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mini_request
      @mini_request = MiniRequest.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def mini_request_params
      params.require(:mini_request).permit(:description, :email)
    end
end
