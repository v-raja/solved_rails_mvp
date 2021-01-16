class SearchController < ApplicationController

  def main

  end

  def home
    @posts = Post.all.order(cached_votes_score: :desc).order(created_at: :desc)
  end

  def recent
    @posts = Post.all.order(created_at: :desc)
    render 'home'
  end

  def requests
    @posts = Request.all.order(cached_votes_score: :desc).order(created_at: :desc)
    render 'home'
  end

  def requests_recent
    @posts = Request.all.order(created_at: :desc)
    render 'home'
  end


end
