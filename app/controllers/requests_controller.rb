class RequestsController < ApplicationController
  before_action :set_niche

  def index
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_niche
      @niche = Niche.friendly.find params[:niche_id]

      # If an old id or a numeric id was used to find the record, then
      # the request path will not match the post_path, and we should do
      # a 301 redirect that uses the current friendly id.
      if params[:niche_id] != @niche.slug
        return redirect_to niche_search_url(@niche), :status => :moved_permanently
      end
    end
end
