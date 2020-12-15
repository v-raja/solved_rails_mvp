class NichesController < ApplicationController
  before_action :set_niche, only: [:show, :search]

  # GET /niches
  # GET /niches.json
  def index
    @niches = niche_type.all
  end

  # GET /niches/1
  # GET /niches/1.json
  def show
  end

  # GET /niches/1/search
  def search

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_niche
      @niche = niche_type.friendly.find params[:id]

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
