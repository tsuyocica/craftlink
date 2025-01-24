class JobApplicationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @job_post = JobPost.find(params[:job_post_id])
    @job_application = @job_post.job_applications.build(application_params)
    @job_application.worker = current_user

    if @job_application.save
      redirect_to @job_post, notice: "応募が完了しました。"
    else
      redirect_to @job_post, alert: "応募に失敗しました。"
    end
  end

  private

  def application_params
    params.require(:job_application).permit(:message)
  end
end
