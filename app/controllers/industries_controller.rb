class IndustriesController < ApplicationController
  before_action :set_industry, only: [:follow, :unfollow]

  def follow
    authorize @industry
    if current_user.nil? && user_params[:email].blank?
      return redirect_to @industry, alert: "Please enter a valid email."
    end

    @user = current_user || User.invite_subscriber!({attributes: user_params}, @industry)
    @user.follow(@industry)
    if current_user
      return redirect_to @industry
    else
      if @user.confirmed?
        return redirect_to @industry, notice: "Successfully subscribed to industry."
      else
        return redirect_to @industry, notice: "Confirm your email to recieve updates."
      end
    end
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

    def user_params
      params.require(:user).permit(:email)
    end
end
