class UsersController < ApplicationController
  
  before_action :set_user, only: [ :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :log_in_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :admin_or_correct_user, only: [:show, :edit, :update]
  before_action :admin_user, only: [:index, :destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: :show
  
  
  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
  end
  
  def index
    @users = User.paginate(page: params[:page]).search(params[:search]).order(:id)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params_user)
    if @user.save
      log_in @user
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
  
  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_path
  end
  
  def edit_basic_info
  end
  
  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
      redirect_to users_path
    else
      flash[:danger] = "#{@user.name}の更新に失敗しました。<br>" + @user.errors.full_messages.join("<br>")
      render :edit_basic_info
    end
  end
  
  
  
  private
  
    def params_user
      params.require(:user).permit(:name, :email, :department, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit( :base_time, :work_time )
    end
    
    
    def admin_or_correct_user
      unless current_user.admin? || current_user?(@user)
        flash[:danger] = "権限がありません。"
        redirect_to root_url
      end
    end
    
    
  
  
  
end
