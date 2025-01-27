class JobApplicationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @job_post = JobPost.find(params[:job_post_id])
    @job_application = @job_post.job_applications.build(application_params)
    @job_application.worker = current_user

    if JobApplication.exists?(worker_id: current_user.id, job_post_id: @job_post.id)
      flash.now[:alert] = "すでにこの募集に応募しています。"
      render "job_posts/show", status: :unprocessable_entity
      return
    end

    if @job_application.save
      flash[:notice] = "応募が完了しました。"
      redirect_to @job_post
    else
      flash.now[:alert] = "応募に失敗しました。"
      render "job_posts/show", status: :unprocessable_entity
    end
  end

  private

  def application_params
    params.require(:job_application).permit(:message)
  end
end
