class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy, :upvote,
                                     :remove_upvote, :follow, :unfollow]
  before_action :set_niche,   only: [:niche_index]


  def niche_index
    set_meta_tags title: "Problems that need to be solved for #{@niche.title}", description: "Requests for solutions for #{@niche.keywords.join(", ")}", reverse: true
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
        format.html { redirect_to @solution }
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
        format.html { redirect_to @solution }
        format.js
      else
        format.html { redirect_to @request, notice: "You haven't voted for the request." }
      end
    end
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
    set_meta_tags title: @request.title, description: @request.description, reverse: true
    if user_signed_in?
      @new_comment = Comment.build_from(@request, current_user, "")
    end
  end


  # GET /requests/1/edit
  def edit
    authorize @request
  end

  # GET /requests/new
  def new
    @request = Request.new
    authorize @request
    @user = User.new
  end

  # POST /requests
  # POST /requests.json
  def create
    authorize Request
    @request = Request.new(request_params)
    @user = current_user || User.new(user_params)
    respond_to do |format|
      if @user.save
        @request.user = @user
        if @request.save

          @user.follow(@request)
          @request.niche_list.each do |n|
            @user.follow(n)
          end

          if current_user
            format.html { redirect_to @request, notice: {title: 'Request was successfully created.', body: "You're now following the niches you posted to." }}
            format.json { render :show, status: :created, location: @request }
          else
            format.html { redirect_to @request, notice: {title: 'Request was successfully created.', body: "You'll recieve an email with a link to confirm you account shortly." }}
          end
        else
          if user_signed_in?
            format.html { render :new }
            format.json { render json: @request.errors, status: :unprocessable_entity }
          else
            # User was just created, let him know he has to confirm his account
            sign_in @user
            flash.now[:notice] = "You have successfully signed up. Please confirm your account within the next 2 hours."
            #  {title: 'You have successfully signed up. Please confirm your account within 2 hours.', data: "An email with a confirmation link will be sent to you shortly."}
            format.html { render :new }
          end
        end

      else
        format.html { render :new }
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
      @request = Request.friendly.find(params[:id])

      if params[:id] != @request.slug
        return redirect_to @request, :status => :moved_permanently
      end
    end

    # Only allow a list of trusted parameters through.
    def request_params
      params.require(:request).permit(:title, :description, niche_list: [])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end

    def set_niche
      if id = params[:industry_id]
        @niche = Industry.friendly.find params[:industry_id]
      elsif id = params[:occupation_id]
        @niche = Occupation.friendly.find params[:occupation_id]
      end
    end
end
