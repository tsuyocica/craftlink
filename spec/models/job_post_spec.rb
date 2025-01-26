require 'rails_helper'

RSpec.describe JobPost, type: :model do
  it "有効な募集が作成できること" do
    job_post = FactoryBot.create(:job_post)
    expect(job_post).to be_valid
  end

  it "タイトルがないと無効" do
    job_post = FactoryBot.build(:job_post, title: nil)
    expect(job_post).not_to be_valid
  end
end