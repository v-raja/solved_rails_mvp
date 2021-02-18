class HomeController < ApplicationController
  # before_action :set_meta
  skip_after_action :verify_authorized
  before_action :authenticate_user!, except: [:niche_index, :all, :signed_out_home, :search_solutions]

  def all
    # if params[:tag]
    #   @posts = Solution.tagged_with(params[:tag], on: :general_tags).includes([:user, :product, :plan])
    # else
    @posts = Solution.front_page.all.top.includes([:product, :plan])
    # end
    set_meta_tags title: "solved: Find new and better solutions to your problems from people like you.",
                  description: "solved is a community of problem solvers and makers helping you find (or build!) better solutions to problems you face. Learn about new ways of doing things in your industry or occupation from people like you all around the world. Give back to the community by sharing your experience with products you love. Connect with budding entrepreneurs and give them feedback on their products to help them build better products for you.",
                  site: nil,
                  canonical: all_url
  end

  def home
    @posts = Solution.by_communities(current_user.niche_list).top.includes([:user, :product, :plan])
    @is_solutions_page = true
    @is_top_results = true
    set_meta_tags title: "solved: Find new and better solutions to your problems from people like you.",
                  description: "solved is a community of problem solvers and makers helping you find (or build!) better solutions to problems you face. Learn about new ways of doing things in your industry or occupation from people like you all around the world. Give back to the community by sharing your experience with products you love. Connect with budding entrepreneurs and give them feedback on their products to help them build better products for you.",
                  site: nil,
                  canonical: home_url
  end


  def recent
    @posts = Solution.by_communities(current_user.niche_list).most_recent
    @is_solutions_page = true
    @is_top_results = false
    render 'home'
  end

  def requests
    @posts = Request.by_communities(current_user.niche_list).top
    @is_solutions_page = false
    @is_top_results = true
    render 'home'
  end

  def requests_recent
    @posts = Request.by_communities(current_user.niche_list).most_recent
    @is_solutions_page = false
    @is_top_results = false
    render 'home'
  end

  def search_solutions
    gon.index_name = 'solutions'
    render layout: false
  end

  private

  # def set_meta
  #   set_meta_tags title: "solved: Find new and better solutions to your problems from people like you.",
  #                 description: "solved is a community of problem solvers and makers helping you find (or build!) better solutions to problems you face. Learn about new ways of doing things in your industry or occupation from people like you all around the world. Give back to the community by sharing your experience with products you love. Connect with budding entrepreneurs and give them feedback on their products to help them build better products for you.",
  #                 site: nil
  #                 canonical: all_url
  # end

end
