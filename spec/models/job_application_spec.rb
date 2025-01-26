require 'rails_helper'

RSpec.describe JobApplication, type: :model do
  it "有効な応募が作成できること" do
    job_application = FactoryBot.create(:job_application)
    expect(job_application).to be_valid
  end

  it "メッセージがないと無効" do
    job_application = FactoryBot.build(:job_application, message: nil)
    expect(job_application).not_to be_valid
  end
end