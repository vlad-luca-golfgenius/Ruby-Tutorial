class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by email: params[:session][:email]

    if user&.authenticate params[:session][:password]
      log_in user
      redirect_to user
    else
      # add err msg
      flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
    log_out
    flash[:success] = "You have been logged out!"
    redirect_to root_url
  end
end
