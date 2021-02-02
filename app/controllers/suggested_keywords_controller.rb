class SuggestedKeywordsController < ApplicationController


  def create
    authorize SuggestedKeyword

    @suggested_keyword = SuggestedKeyword.new(suggested_keyword_params.slice('keyword', 'industry_slug', 'occupation_slug'))
    if user_signed_in?
      @suggested_keyword.user = current_user
    end

    if @suggested_keyword.save
      if suggested_keyword_params[:type] == "Industry"
        redirect_to industry_path(suggested_keyword_params[:niche_id]), notice: { title: "Thanks for the suggestion!", data: "We'll review it shortly."}
      else
        redirect_to occupation_path(suggested_keyword_params[:niche_id]), notice: { title: "Thanks for the suggestion!", data: "We'll review it shortly."}
      end
    else
      if suggested_keyword_params[:type] == "Industry"
        redirect_to industry_path(suggested_keyword_params[:niche_id]), alert: "Couldn't save suggestion."
      else
        redirect_to occupation_path(suggested_keyword_params[:niche_id]), alert: "Couldn't save suggestion."
      end
    end
  end

  def destroy
    authorize SuggestedKeyword

  end

  private

  def suggested_keyword_params
    params.require(:suggested_keyword).permit(:keyword, :industry_slug, :occupation_slug, :niche_id, :type)
  end

end
