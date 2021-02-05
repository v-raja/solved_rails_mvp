class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /lists
  # GET /lists.json
  # def index
  #   @lists = List.all
  # end

  # GET /lists/1
  # GET /lists/1.json
  def show
  end

  # GET /lists/new
  # def new
  #   @list = List.new
  # end

  # GET /lists/1/edit
  # def edit
  # end

  # POST /lists
  # POST /lists.json
  # def create
  #   @list = List.new(list_params)

  #   respond_to do |format|
  #     if @list.save
  #       format.html { redirect_to @list, notice: 'List was successfully created.' }
  #       format.json { render :show, status: :created, location: @list }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @list.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # PATCH/PUT /lists/1
  # PATCH/PUT /lists/1.json
  # def update
  #   respond_to do |format|
  #     if @list.update(list_params)
  #       format.html { redirect_to @list, notice: 'List was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @list }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @list.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /lists/1
  # DELETE /lists/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.friendly.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def group_params
      params.fetch(:group, {})
    end
end
