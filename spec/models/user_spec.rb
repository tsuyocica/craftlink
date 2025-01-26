require 'rails_helper'

RSpec.describe User, type: :model do
  describe "ユーザーの新規登録" do
    let(:user) { FactoryBot.build(:user) }

    context "ユーザーが有効な場合" do
      it "全ての属性が適切に設定されていれば有効" do
        expect(user).to be_valid
      end
    end

    context "ユーザーが無効な場合" do
      it "名前が空だと無効" do
        user.name = ""
        expect(user).not_to be_valid
        expect(user.errors[:name]).to include("を入力してください")
      end

      it "メールアドレスが空だと無効" do
        user.email = ""
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("を入力してください")
      end

      it "パスワードが空だと無効" do
        user.password = ""
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("を入力してください")
      end

      it "メールアドレスが重複すると無効" do
        FactoryBot.create(:user, email: user.email)
        expect(user).not_to be_valid
        expect(user.errors[:email]).to include("はすでに存在します")
      end

      it "role が 'owner' または 'worker' 以外の場合無効" do
        user.role = "admin"
        expect(user).not_to be_valid
        expect(user.errors[:role]).to include("は一覧にありません")
      end
    end
  end
end