require 'rails_helper'

RSpec.describe JobPost, type: :model do
  let(:owner) { FactoryBot.create(:user, role: "owner") }
  let(:job_post) { FactoryBot.build(:job_post, owner: owner) } # build を使用してデータを作成（DBには保存しない）

  describe "作業募集のバリデーション" do
    context "有効なデータの場合" do
      it "全ての属性が適切に設定されていれば有効" do
        expect(job_post).to be_valid
      end
    end

    context "無効なデータの場合" do
      it "タイトルが空だと無効" do
        job_post.title = ""
        expect(job_post).not_to be_valid
        expect(job_post.errors[:title]).to include("募集タイトルを入力してください")
      end

      it "タイトルが100文字を超えると無効" do
        job_post.title = "あ" * 101
        expect(job_post).not_to be_valid
        expect(job_post.errors[:title]).to include("募集タイトルは100文字以内で入力してください")
      end

      it "作業内容が空だと無効" do
        job_post.description = ""
        expect(job_post).not_to be_valid
        expect(job_post.errors[:description]).to include("作業内容を入力してください")
      end

      it "作業内容が1000文字を超えると無効" do
        job_post.description = "あ" * 1001
        expect(job_post).not_to be_valid
        expect(job_post.errors[:description]).to include("作業内容は1000文字以内で入力してください")
      end

      it "募集人数が1未満だと無効" do
        job_post.num_workers = 0
        expect(job_post).not_to be_valid
        expect(job_post.errors[:num_workers]).to include("募集人数は1人以上にしてください")
      end

      it "募集人数が11人以上だと無効" do
        job_post.num_workers = 11
        expect(job_post).not_to be_valid
        expect(job_post.errors[:num_workers]).to include("募集人数は10人以下にしてください")
      end

      it "報酬額が3000円未満だと無効" do
        job_post.pay_amount = 2000
        expect(job_post).not_to be_valid
        expect(job_post.errors[:pay_amount]).to include("報酬額は3,000円以上にしてください")
      end

      it "支払い方法が「hourly」「daily」「fixed」以外だと無効" do
        job_post.pay_type = "monthly"
        expect(job_post).not_to be_valid
        expect(job_post.errors[:pay_type]).to include("支払い方法は「時給」「日給」「固定給」のいずれかにしてください")
      end

      it "ステータスが「open」「closed」「filled」以外だと無効" do
        job_post.status = "unknown"
        expect(job_post).not_to be_valid
        expect(job_post.errors[:status]).to include("募集ステータスは「募集中」「締切」「成立」のいずれかにしてください")
      end
    end
  end

  describe "カスタムメソッドの動作確認" do
    it "status_label が正しく日本語に変換される" do
      job_post.status = "open"
      expect(job_post.status_label).to eq("募集中")

      job_post.status = "closed"
      expect(job_post.status_label).to eq("締切")

      job_post.status = "filled"
      expect(job_post.status_label).to eq("成立")
    end

    it "pay_type_label が正しく日本語に変換される" do
      job_post.pay_type = "hourly"
      expect(job_post.pay_type_label).to eq("時給")

      job_post.pay_type = "daily"
      expect(job_post.pay_type_label).to eq("日給")

      job_post.pay_type = "fixed"
      expect(job_post.pay_type_label).to eq("固定給")
    end
  end
end