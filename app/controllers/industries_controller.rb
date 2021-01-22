class IndustriesController < ApplicationController
  before_action :set_industry, only: [:follow, :unfollow]

  def follow
    authorize @industry
    current_user.follow(@industry)
    redirect_to @industry
  end

  def unfollow
    authorize @industry
    current_user.stop_following(@industry)
    redirect_to @industry
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_industry
      @industry = Industry.friendly.find params[:id]

      # If an old id or a numeric id was used to find the record, then
      # the request path will not match the solution_path, and we should do
      # a 301 redirect that uses the current friendly id.
      if params[:id] != @industry.slug
        return redirect_to @industry, :status => :moved_permanently
      end
    end

    # Only allow a list of trusted parameters through.
    def industry_params
      params.fetch(:industry, {})
    end
end
