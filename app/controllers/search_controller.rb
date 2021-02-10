class SearchController < ApplicationController
  # before_action :set_meta
  skip_after_action :verify_authorized

  def communities
    if user_signed_in?
      redirect_to controller: :home, action: :home
    end
  end

  def solutions
    gon.index_name = 'solutions'
    set_meta_tags title: "solved: Find new and better solutions to your problems from people like you.",
                  description: "solved is a community of problem solvers and makers helping you find (or build!) better solutions to problems you face. Learn about new ways of doing things in your industry or occupation from people like you all around the world. Give back to the community by sharing your experience with products you love. Connect with budding entrepreneurs and give them feedback on their products to help them build better products for you.",
                  site: nil,
                  canonical: search_solutions_url
  end

  private

  # def set_meta
  #   set_meta_tags title: "solved: Find new and better solutions to your problems from people like you.",
  #                 description: "solved is a community of problem solvers and makers helping you find (or build!) better solutions to problems you face. Learn about new ways of doing things in your industry or occupation from people like you all around the world. Give back to the community by sharing your experience with products you love. Connect with budding entrepreneurs and give them feedback on their products to help them build better products for you.",
  #                 site: nil,
  #                 canonical: root_url

  # end


end
