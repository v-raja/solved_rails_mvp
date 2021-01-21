class IndustriesController < ApplicationController
  before_action :set_industry, only: [:show, :edit, :update, :destroy, :follow, :unfollow]

  # GET /industries
  # GET /industries.json
  def index
    @industries = Industry.all
  end

  # GET /industries/1/edit
  def edit
  end

  def follow
    authorize @industry
    current_user.follow(@industry)
    redirect_to industry_path(@industry)
  end

  def unfollow
    authorize @industry
    current_user.stop_following(@industry)
    redirect_to industry_path(@industry)
  end

  # PATCH/PUT /industries/1
  # PATCH/PUT /industries/1.json
  def update
    respond_to do |format|
      if @industry.update(industry_params)
        format.html { redirect_to @industry, notice: 'Industry was successfully updated.' }
        format.json { render :show, status: :ok, location: @industry }
      else
        format.html { render :edit }
        format.json { render json: @industry.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_industry
      @industry = Industry.friendly.find params[:id]

      # If an old id or a numeric id was used to find the record, then
      # the request path will not match the solution_path, and we should do
      # a 301 redirect that uses the current friendly id.
      if params[:id] != @industry.slug
        return redirect_to @industry, :status => :moved_permanently
      end
    end

    # Only allow a list of trusted parameters through.
    def industry_params
      params.fetch(:industry, {})
    end
end
