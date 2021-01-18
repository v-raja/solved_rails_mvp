class IndustryCategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    @industry_categories = IndustryCategory.all
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @industry_category = IndustryCategory.friendly.find params[:id]

      # If an old id or a numeric id was used to find the record, then
      # the request path will not match the solution_path, and we should do
      # a 301 redirect that uses the current friendly id.
      if params[:id] != @industry_category.slug
        return redirect_to @industry_category, :status => :moved_permanently
      end
    end

    # Only allow a list of trusted parameters through.
    def industry_category_params
      params.require(:category).permit(:title, :description, :code, :slug)
    end

    # def category_types
    #   ["IndustryCategory", "OccupationCategory"]
    # end

    # def category_type
    #   params[:type].constantize if params[:type].in? category_types
    # end
end
