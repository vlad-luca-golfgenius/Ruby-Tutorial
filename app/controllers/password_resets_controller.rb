class PasswordResetsController < ApplicationController

  # GET /password_resets/new
  def new
  end

  # POST /password_resets
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  # GET /password_resets/<token>/edit
  def edit
  end

  # PATCH /password_resets/<token>
  def update
  end
end
