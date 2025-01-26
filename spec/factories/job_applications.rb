FactoryBot.define do
  factory :job_application do
    association :job_post
    association :worker, factory: :user
    message { Faker::Lorem.sentence(word_count: 10) }
    status { %w[pending approved rejected confirmed].sample }
  end
end