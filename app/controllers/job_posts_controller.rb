class JobPostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @job_posts = JobPost.all.order(created_at: :desc)
  end

  def show
    @job_post = JobPost.find(params[:id])
    @job_application = JobApplication.new
  end

  def new
    @job_post = JobPost.new
  end

  def create
    @job_post = current_user.job_posts.build(job_post_params)
    if @job_post.save
      redirect_to @job_post, notice: "作業募集を作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def job_post_params
    params.require(:job_post).permit(:title, :description, :num_workers, :work_date, :location, :pay_amount, :pay_type, :status)
  end
end