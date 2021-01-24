class OccupationCategoriesController < ApplicationController
  before_action :set_occupation_category, only: [:show]

  # GET /categories
  # GET /categories.json
  def index
    @occupation_categories = OccupationCategory.all
    authorize @occupation_categories
    set_meta_tags title: "Explore by occupations to find your niche",
                  description: "Explore by occupations to find your niche. Find the best new solutions for your occupation niche.",
                  reverse: true
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    authorize @occupation_category
    set_meta_tags title: "Explore by occupations to find your niche",
                  description: "Explore by industries within the #{@occupation_category.title} subsector to find your niche. Find the best new solutions for your industry niche.",
                  reverse: true
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_occupation_category
    @occupation_category = OccupationCategory.friendly.find params[:id]

    # If an old id or a numeric id was used to find the record, then
    # the request path will not match the solution_path, and we should do
    # a 301 redirect that uses the current friendly id.
    if params[:id] != @occupation_category.slug
      return redirect_to @occupation_category, :status => :moved_permanently
    end
  end

  # Only allow a list of trusted parameters through.
  def occupation_category_params
    params.require(:category).permit(:title, :description, :code, :slug)
  end
end
