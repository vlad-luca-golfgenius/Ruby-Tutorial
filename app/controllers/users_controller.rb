class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :followers, :following]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  # /GET users/
  def index
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  # /GET user/<id>
  def show
    # self.params (fancy method that can do a lot, not a simple dict)
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])

    redirect_to root_url unless @user.activated?
  end

  # /GET /signin
  def new
    @user = User.new
  end

  # /POST /signin
  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  # /GET user/<id>/edit
  def edit
    @user = User.find(params[:id])
  end

  # /PATCH user/<id>
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  # /DELETE user/<id>
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  # GET /user/<id>/following
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  # GET /user/<id>/followers
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def delete_relationships

  end
end
