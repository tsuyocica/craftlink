require 'rails_helper'

RSpec.describe JobApplication, type: :model do
  let!(:job_post) { FactoryBot.create(:job_post) }
  let!(:worker) { FactoryBot.create(:user, role: "worker") }

  describe "作業員の応募のバリデーション" do
    it "有効なデータであれば保存できる" do
      job_application = FactoryBot.build(:job_application, job_post: job_post, worker: worker)
      expect(job_application).to be_valid
    end

    it "job_postがない場合は無効" do
      job_application = FactoryBot.build(:job_application, job_post: nil, worker: worker)
      expect(job_application).not_to be_valid
      expect(job_application.errors[:job_post]).to include("応募する作業募集を指定してください")
    end

    it "workerがない場合は無効" do
      job_application = FactoryBot.build(:job_application, job_post: job_post, worker: nil)
      expect(job_application).not_to be_valid
      expect(job_application.errors[:worker]).to include("応募者を指定してください")
    end

    it "メッセージが空の場合は無効" do
      job_application = FactoryBot.build(:job_application, job_post: job_post, worker: worker, message: "")
      expect(job_application).not_to be_valid
      expect(job_application.errors[:message]).to include("応募メッセージを入力してください")
    end

    it "ステータスが未設定の場合はデフォルトの '応募中' になる" do
      job_application = JobApplication.new(job_post: job_post, worker: worker) # `status: nil` を省略
      job_application.valid?  # バリデーションを実行
      expect(job_application.status).to eq("応募中")
    end

    it "ステータスが 'pending', 'approved', 'rejected', 'confirmed' のいずれかでない場合は無効" do
      job_application = FactoryBot.build(:job_application, job_post: job_post, worker: worker, status: "invalid_status")
      expect(job_application).not_to be_valid
      expect(job_application.errors[:status]).to include("応募ステータスは「応募中」「承認」「却下」「確定」のいずれかにしてください")
    end

    it "同じ作業員が同じ募集に2回応募できない" do
      FactoryBot.create(:job_application, job_post: job_post, worker: worker)
      duplicate_application = FactoryBot.build(:job_application, job_post: job_post, worker: worker)
      expect(duplicate_application).not_to be_valid
      expect(duplicate_application.errors[:worker_id]).to include("既に応募済みです")
    end
  end
end