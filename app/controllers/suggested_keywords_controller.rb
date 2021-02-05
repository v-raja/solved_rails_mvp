class SuggestedKeywordsController < ApplicationController


  def create
    authorize SuggestedKeyword

    @suggested_keyword = SuggestedKeyword.new(suggested_keyword_params)
    if user_signed_in?
      @suggested_keyword.user = current_user
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
