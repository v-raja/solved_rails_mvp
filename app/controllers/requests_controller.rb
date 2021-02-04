class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy, :upvote,
                                     :remove_upvote, :follow, :unfollow]
  before_action :set_niche,   only: [:niche_index]
  etag { current_user.try :id }


  def niche_index
    set_meta_tags title: "Problems that need to be solved for #{@niche.title}",
                  description: "Requests for solutions for #{@niche.keywords}",
                  reverse: true,
                  keywords: @niche.keyword_list,
                  canonical: polymorphic_url([@niche, :requests])
  end

  def follow
    authorize @request
    current_user.follow(@request)
    redirect_to @request
  end

  def unfollow
    authorize @request
    current_user.stop_following(@request)
    redirect_to @request
  end

  def upvote
    authorize @request
    respond_to do |format|
      if !current_user.voted_for? @request
        @request.liked_by current_user
        format.html { redirect_to @request }
        format.js
      else
        format.html { redirect_to @request, notice: "You've already upvoted the request." }
      end
    end
  end

  def remove_upvote
    authorize @request
    respond_to do |format|
      if current_user.voted_for? @request
        @request.unliked_by current_user
        format.html { redirect_to @request }
        format.js
      else
        format.html { redirect_to @request, notice: "You haven't voted for the request." }
      end
    end
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
    # fresh_when @request
    set_meta_tags title: @request.title,
                  description: @request.description,
                  reverse: true,
                  canonical: request_url(@request)
    if user_signed_in?
      @new_comment = Comment.build_from(@request, current_user, "")
    end
  end


  # GET /requests/1/edit
  def edit
    authorize @request
    set_meta_tags noindex: true
    @use_select_community = true
  end

  # GET /requests/new
  def new
    @request = Request.new
    authorize @request
    @user = User.new
    set_meta_tags title: "Request for a solution to your problem",
                  description: "Create a request for a software solution from makers all around the world.",
                  reverse: true,
                  canonical: new_request_url
    @use_select_community = true
  end

  # POST /requests
  # POST /requests.json
  def create
    authorize Request
    @request = Request.new(request_params)
    respond_to do |format|
      if user_signed_in?
        # Handle creation like normal
        @request.user = current_user
        if @request.save
          current_user.follow(@request)
          @request.niche_list.each do |n|
            current_user.follow(n)
          end

          format.html { redirect_to @request, notice: {title: 'Request was successfully created.', body: "You're now following the communities you posted to." }}
          format.json { render :show, status: :created, location: @request }
        else
          format.html { render :new }
        end
      else
        # Find if user exists
        @user = User.find_by(email: user_params[:email])
        if @user.present?
          # Make user login to create if email address exists.
          flash[:now] = "Email address has already been taken. Please sign in to post."
          @request.valid?
          @request.errors.messages.except!(:user) #remove password from errors
          format.html { render :new }
        else
          @user = User.new(user_params)
          @user.valid?
          @user.errors.messages.except!(:password, :thumbnail_url) #remove password from errors
          @request.valid?
          @request.errors.messages.except!(:user) #remove password from errors
          if (@user.errors.any? || @request.errors.any?)
            format.html { render :new }
          else
            @user.invite!
            @request.user = @user
            @request.save
            @user.follow(@request)
            @request.niche_list.each do |n|
              @user.follow(n)
            end
            format.html { redirect_to @request, notice: {title: 'Request was successfully created.', body: "Please confirm your email to finish posting your request." }}
            format.json { render :show, status: :created, location: @request }
          end
        end
      end
    end
  end

  # PATCH/PUT /requests/1
  # PATCH/PUT /requests/1.json
  def update
    authorize @request
    respond_to do |format|
      if @request.update(request_params)

        current_user.follow(@request)
        @request.niche_list.each do |n|
          current_user.follow(n)
        end

        format.html { redirect_to @request, notice: 'Request was successfully updated.' }
        format.json { render :show, status: :ok, location: @request }
      else
        format.html { render :edit }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    authorize @request
    @request.destroy
    respond_to do |format|
      format.html { redirect_to requests_url, notice: 'Request was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find_by_slug(params[:id])

      if params[:id] != @request.slug
        return redirect_to @request, :status => :moved_permanently
      end
    end

    # Only allow a list of trusted parameters through.
    def request_params
      params.require(:request).permit(:title, :description, niche_list: [])
    end

    def user_params
      params.require(:user).permit(:name, :email)
    end

    def set_niche
      if id = params[:industry_id]
        @niche = Industry.find_by_slug params[:industry_id]
      elsif id = params[:occupation_id]
        @niche = Occupation.find_by_slug params[:occupation_id]
      end
    end
end
