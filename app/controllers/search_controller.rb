class SearchController < ApplicationController
  before_action :set_niche, only: [:niche_index]
  before_action :set_meta, except: :niche_index
  skip_after_action :verify_authorized


  def niche_index
    set_meta_tags title: "Search for a solution for #{@niche.title}",
                  description: "Find the best new solutions for #{@niche.title}",
                  reverse: true,
                  canonical: polymorphic_url([@niche, :search])
  end

  def home

    if params[:tag]
      @solutions = Solution.tagged_with(params[:tag], on: :general_tags)
    else
      @solutions = Solution.all.top
    end
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

  def set_meta
    set_meta_tags title: "solved: Find new and better solutions to your problems from people like you.",
                  description: "solved is a community of problem solvers and makers helping you find (or build!) better solutions to problems you face. Learn about new ways of doing things in your industry or occupation from people like you all around the world. Give back to the community by sharing your experience with products you love. Connect with budding entrepreneurs and give them feedback on their products to help them build better products for you.",
                  site: nil,
                  canonical: root_url
    # Stay in the loop by subscribing to your industry / occupation niche to get a weekly newsletter of all the best solutions of the week
    # Better yet, create a request for a solution to that painful problem you hate solving everyday.
  end

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
