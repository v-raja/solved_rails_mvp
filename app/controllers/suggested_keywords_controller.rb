class SuggestedKeywordsController < ApplicationController


  def create
    authorize SuggestedKeyword
    # byebug

    @suggested_keyword = SuggestedKeyword.new(suggested_keyword_params)
    if user_signed_in?
      @suggested_keyword.user = current_user
    end

    if user_signed_in? && current_user.admin?
      if params[:add_directly] == "1"
        if !suggested_keyword_params[:industry_slug].blank?
          niche = Industry.find_by_slug(suggested_keyword_params[:industry_slug])
        else
          niche = Occupation.find_by_slug(suggested_keyword_params[:occupation_slug])
        end
        niche.add_user_suggested_keyword(suggested_keyword_params[:keyword])
      end
    end
    if @suggested_keyword.save
      flash[:notice] = "Thanks for the suggestion! We'll review it shortly."
      redirect_back fallback_location: root_path
      # if suggested_keyword_params[:type] == "Industry"
      #   redirect_back fallback_location: root_path
      #   redirect_to industry_path(suggested_keyword_params[:niche_id]), notice: { title: "Thanks for the suggestion!", data: "We'll review it shortly."}
      # else
      #   redirect_to occupation_path(suggested_keyword_params[:niche_id]), notice: { title: "Thanks for the suggestion!", data: "We'll review it shortly."}
      # end
    else
      flash[:alert] = "Couldn't save your suggestion."
      redirect_back fallback_location: root_path
      # if suggested_keyword_params[:type] == "Industry"
      #   redirect_to industry_path(suggested_keyword_params[:niche_id]), alert: "Couldn't save suggestion."
      # else
      #   redirect_to occupation_path(suggested_keyword_params[:niche_id]), alert: "Couldn't save suggestion."
      # end
    end
  end

  def destroy
    authorize SuggestedKeyword

  end

  private

  def suggested_keyword_params
    params.require(:suggested_keyword).permit(:keyword, :industry_slug, :occupation_slug)
  end

end
