class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by email: params[:session][:email]

    if user&.authenticate params[:session][:password]
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      redirect_to user
    else
      # add err msg
      flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
    # TODO why is there a bug when you invert the following 2 lines?
    log_out if logged_in?
    flash[:success] = "You have been logged out!"
    redirect_to root_url
  end
end
