class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @is_my_page = (@user == current_user)# 自分のマイページなら、編集リンクを表示するためにフラグを設定
  end

  def show_owner
    @user = User.find(params[:id])
    @is_my_page = (@user == current_user)
    render "users/show_owner"
  end

  def show_worker
    @user = User.find(params[:id])
    @is_my_page = (@user == current_user)
    render "users/show_worker"
  end
end
