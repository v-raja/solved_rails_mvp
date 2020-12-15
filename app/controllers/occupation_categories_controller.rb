class OccupationCategoriesController < ApplicationController
  before_action :set_occupation_category, only: [:show, :edit, :update, :destroy]

  # GET /categories
  # GET /categories.json
  def index
    @occupation_categories = OccupationCategory.all
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_occupation_category
      @occupation_category = OccupationCategory.friendly.find params[:id]

      # If an old id or a numeric id was used to find the record, then
      # the request path will not match the post_path, and we should do
      # a 301 redirect that uses the current friendly id.
      if params[:id] != @occupation_category.slug
        return redirect_to @occupation_category, :status => :moved_permanently
      end
    end

    # Only allow a list of trusted parameters through.
    def occupation_category_params
      params.require(:category).permit(:title, :description, :code, :slug)
    end

    # def category_types
    #   ["OccupationCategory", "OccupationCategory"]
    # end

    # def category_type
    #   params[:type].constantize if params[:type].in? category_types
    # end
end
