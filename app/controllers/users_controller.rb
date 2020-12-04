class UsersController < ApplicationController
  
  before_action :set_user, only: [ :show, :edit, :update]
  before_action :log_in_user, only: [:show, :edit, :update]
  before_action :admin_or_correct_user, only: :show
  before_action :admin_user, only: :index
  
  
  def show
  end
  
  def index
    @users = User.paginate(page: params[:page])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params_user)
    if @user.save
      flash[:success] = "ユーザーを新規作成しました。"
      redirect_to @user
    else
      render :new
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(params_user)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      flash.now[:danger] = "ユーザー情報の更新に失敗しました。"
      render :edit
    end
  end
  
  
  
  private
    def params_user
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
  def set_user
    @user = User.find(params[:id])
  end
  
    # ログインユーザーのみが使えるようにする認可機能
  def log_in_user
    unless logged_in?
      flash[:danger] = "ログインしてください。"
      redirect_to login_url
    end
  end
  
  # 管理者権限を持っているユーザーしか使えないようにする認可機能
  def admin_user
    unless current_user.admin?
      flash[:danger] = "権限がありません"
      redirect_to root_url
    end
  end
  
  # 現在ログインしているユーザーとページを訪れているユーザーが同一の場合のみ認可する機能
  def correct_user
    unless current_user?(@user)
      flash[:danger] = "権限がありません。"
      redirect_to root_url
    end
  end
  
  def admin_or_correct_user
    unless current_user.admin? || current_user?(@user)
      flash[:danger] = "権限がありません。"
      redirect_to root_url
    end
  end
  
  
  
end
