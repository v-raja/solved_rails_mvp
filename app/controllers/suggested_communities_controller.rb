class SuggestedCommunitiesController < ApplicationController


  def create
    authorize SuggestedCommunity

    @suggested_community = SuggestedCommunity.new(suggested_community_params)
    if user_signed_in?
      @suggested_community.user = current_user
    end

    if @suggested_community.save
      flash[:notice] = "Thanks for the suggestion! We'll review it shortly."
      redirect_back fallback_location: industry_categories_path
    else
      flash[:alert] = "Couldn't save your suggestion."
      redirect_back fallback_location: industry_categories_path
    end
  end

  def destroy
    authorize SuggestedCommunity

  end

  private

  def suggested_community_params
    params.require(:suggested_community).permit(:community, :community_type)
  end

end
