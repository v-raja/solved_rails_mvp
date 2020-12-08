class NichesController < ApplicationController
  before_action :set_niche, only: [:show, :edit, :update, :destroy]

  # GET /niches
  # GET /niches.json
  def index
    @niches = Niche.all
  end

  # GET /niches/1
  # GET /niches/1.json
  def show
  end

  # GET /niches/new
  def new
    @niche = Niche.new
  end

  # GET /niches/1/edit
  def edit
  end

  # POST /niches
  # POST /niches.json
  def create
    @niche = Niche.new(niche_params)

    respond_to do |format|
      if @niche.save
        format.html { redirect_to @niche, notice: 'Niche was successfully created.' }
        format.json { render :show, status: :created, location: @niche }
      else
        format.html { render :new }
        format.json { render json: @niche.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /niches/1
  # PATCH/PUT /niches/1.json
  def update
    respond_to do |format|
      if @niche.update(niche_params)
        format.html { redirect_to @niche, notice: 'Niche was successfully updated.' }
        format.json { render :show, status: :ok, location: @niche }
      else
        format.html { render :edit }
        format.json { render json: @niche.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /niches/1
  # DELETE /niches/1.json
  def destroy
    @niche.destroy
    respond_to do |format|
      format.html { redirect_to niches_url, notice: 'Niche was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_niche
      @niche = Niche.friendly.find params[:id]

      # If an old id or a numeric id was used to find the record, then
      # the request path will not match the post_path, and we should do
      # a 301 redirect that uses the current friendly id.
      if params[:id] != @niche.slug
        return redirect_to @niche, :status => :moved_permanently
      end
    end

    # Only allow a list of trusted parameters through.
    def niche_params
      params.require(:niche).permit(:title, :description, :code, :slug)
    end
end
