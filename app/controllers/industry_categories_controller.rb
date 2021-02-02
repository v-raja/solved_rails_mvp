class IndustryCategoriesController < ApplicationController
  before_action :set_category, only: [:show]

  # GET /categories
  # GET /categories.json
  def index
    @industry_categories = IndustryCategory.all
    authorize @industry_categories
    set_meta_tags title: "Explore by industries to find your niche",
                  description: "Explore by industries to find your niche. Find the best new solutions for your industry niche.",
                  reverse: true,
                  canonical: industry_categories_url
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    authorize @industry_category
    set_meta_tags title: "Explore by industries to find your niche",
                  description: "Explore by industries within the #{@industry_category.title} subsector to find your niche. Find the best new solutions for your industry niche.",
                  reverse: true,
                  canonical: industry_category_url(@industry_category)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @industry_category = IndustryCategory.find_by_slug params[:id]

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

end
