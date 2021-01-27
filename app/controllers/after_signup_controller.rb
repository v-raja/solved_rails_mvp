class AfterSignupController < ApplicationController
  include Wicked::Wizard
  include Wicked::Wizard::Translated

  before_action :authenticate_user!
  skip_after_action :verify_authorized


  layout 'after_signup'

  steps :confirm_niche, :confirm_bio

  def show
    @user = current_user
    @user.save
    # byebug
    render_wizard
    set_meta_tags title: "Welcome to sovled!", site: false, nofollow: true, noindex: true
  end

  def update
    @user = current_user
    case wizard_value(step)
    when "confirm_niche"
      @user.update(confirm_niche_params)
      if @user.niche_list.blank? || @user.niche_list.size < 1
        return render_wizard
      end
    when "confirm_bio"
      thumbnail_url = @user.thumbnail_url
      @user.assign_attributes(confirm_bio_params)
      @user.thumbnail_url = thumbnail_url unless confirm_bio_params[:thumbnail_url].present?
    end
    bypass_sign_in(@user) # needed for devise
    render_wizard @user
  end

  def finish_wizard_path
    root_path
  end

  private

  def confirm_bio_params
    params.require(:user).permit(:bio, :thumbnail_url)
  end

  def confirm_niche_params
    params.require(:user).permit(:name, niche_list: [])
  end
end
