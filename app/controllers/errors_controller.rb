class ErrorsController < ApplicationController
  skip_after_action :verify_authorized

  def not_found
    set_meta_tags noindex: true, title: "Page not found", reverse: true
    render status: 404
  end

  def unprocessable_entity
    set_meta_tags noindex: true
    render status: 422
  end

  def server_error
    set_meta_tags noindex: true
    render status: 500
  end

  def robots
    respond_to :text
  end
end
