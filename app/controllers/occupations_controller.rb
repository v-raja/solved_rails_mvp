class OccupationsController < ApplicationController
  before_action :set_occupation, only: [:follow, :unfollow]

  def follow
    authorize @occupation
    current_user.follow(@occupation)
    redirect_to @occupation
  end

  def unfollow
    authorize @occupation
    current_user.stop_following(@occupation)
    redirect_to @occupation
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_occupation
      @occupation = Occupation.friendly.find params[:id]

      # If an old id or a numeric id was used to find the record, then
      # the request path will not match the solution_path, and we should do
      # a 301 redirect that uses the current friendly id.
      if params[:id] != @occupation.slug
        return redirect_to @occupation, :status => :moved_permanently
      end
    end

    # Only allow a list of trusted parameters through.
    def occupation_params
      params.fetch(:occupation, {})
    end
end
