FactoryBot.define do
  factory :job_post do
    association :owner, factory: :user
    title { Faker::Job.field + "の補助作業" } # 日本の業種名を使用
    description { Faker::Lorem.sentence(word_count: 15) }
    num_workers { rand(1..5) }
    work_date { Faker::Date.forward(days: 30) }
    location { Faker::Address.city + Faker::Address.street_address } # 日本の住所
    pay_amount { rand(8000..30000) } # 日本の報酬相場
    pay_type { %w[hourly daily fixed].sample }
    status { %w[open closed filled].sample }
  end
end