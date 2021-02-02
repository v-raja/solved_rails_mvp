class OccupationsController < ApplicationController
  before_action :set_occupation, only: [:follow, :unfollow]

  def follow
    authorize @occupation

    if current_user.nil? && user_params[:email].blank?
      return redirect_to @occupation, alert: "Please enter a valid email."
    end

    @user = current_user || User.invite_subscriber!({attributes: user_params}, @occupation)
    @user.follow(@occupation)
    if current_user
      return redirect_to @occupation
    else
      if @user.confirmed?
        return redirect_to @occupation, notice: "You're now following #{@occupation.title}."
      else
        return redirect_to @occupation, notice: "Confirm your email to finish signing up."
      end
    end
  end

  def unfollow
    authorize @occupation
    current_user.stop_following(@occupation)
    redirect_to @occupation
  end



  private
    # Use callbacks to share common setup or constraints between actions.
    def set_occupation
      @occupation = Occupation.find_by_slug params[:id]

      # If an old id or a numeric id was used to find the record, then
      # the request path will not match the solution_path, and we should do
      # a 301 redirect that uses the current friendly id.
      if params[:id] != @occupation.slug
        return redirect_to @occupation, :status => :moved_permanently
      end
    end

    def user_params
      params.require(:user).permit(:email)
    end

    # Only allow a list of trusted parameters through.
    def occupation_params
      params.fetch(:occupation, {})
    end
end
