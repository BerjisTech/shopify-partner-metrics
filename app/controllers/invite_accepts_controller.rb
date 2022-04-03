class InviteAcceptsController < ApplicationController
  before_action :set_invite_accept, only: %i[ show edit update destroy ]

  # GET /invite_accepts or /invite_accepts.json
  def index
    @invite_accepts = InviteAccept.all
  end

  # GET /invite_accepts/1 or /invite_accepts/1.json
  def show
  end

  # GET /invite_accepts/new
  def new
    @invite_accept = InviteAccept.new
  end

  # GET /invite_accepts/1/edit
  def edit
  end

  # POST /invite_accepts or /invite_accepts.json
  def create
    @invite_accept = InviteAccept.new(invite_accept_params)

    respond_to do |format|
      if @invite_accept.save
        format.html { redirect_to invite_accept_url(@invite_accept), notice: "Invite accept was successfully created." }
        format.json { render :show, status: :created, location: @invite_accept }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @invite_accept.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invite_accepts/1 or /invite_accepts/1.json
  def update
    respond_to do |format|
      if @invite_accept.update(invite_accept_params)
        format.html { redirect_to invite_accept_url(@invite_accept), notice: "Invite accept was successfully updated." }
        format.json { render :show, status: :ok, location: @invite_accept }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invite_accept.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invite_accepts/1 or /invite_accepts/1.json
  def destroy
    @invite_accept.destroy

    respond_to do |format|
      format.html { redirect_to invite_accepts_url, notice: "Invite accept was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invite_accept
      @invite_accept = InviteAccept.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def invite_accept_params
      params.require(:invite_accept).permit(:user_id, :invite_id)
    end
end
