FactoryBot.define do
  factory :user do
    name          { Faker::Name.name }
    email         { Faker::Internet.email }
    password      { "password" }
    password_confirmation { "password" } # Devise のバリデーション用
    role          { %w[owner worker].sample } # 依頼者 or 作業員をランダムに設定
    qualification { "第二種電気工事士" } # 資格のデフォルト値
    experience    { "電気工事経験5年、キュービクル施工経験あり" } # 🔹 `experience` を追加
  end
end