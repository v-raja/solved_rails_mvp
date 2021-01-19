class SearchController < ApplicationController
  before_action :set_niche, only: [:niche_index]

  def niche_index

  end

  def home
    @solutions = Solution.all.top
    # order(cached_votes_score: :desc).order(created_at: :desc)
  end

  def recent
    @solutions = Solution.all
    render 'home'
  end

  def requests
    @solutions = Request.all.top
    render 'home'
  end

  def requests_recent
    @solutions = Request.all
    render 'home'
  end

  private

  def set_niche
    if params[:industry_id]
      @niche = Industry.friendly.find params[:industry_id]
    else
      @niche = Occupation.friendly.find params[:occupation_id]
    end

    # If an old id or a numeric id was used to find the record, then
    # the request path will not match the solution_path, and we should do
    # a 301 redirect that uses the current friendly id.
    id = params[:industry_id] || params[:occupation_id]
    if id != @niche.slug
      return redirect_to @niche, :status => :moved_permanently
    end

  end

end
