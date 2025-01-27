class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # アソシエーション
  has_many :job_posts, foreign_key: "owner_id", dependent: :destroy # 依頼者の募集案件
  has_many :job_applications, foreign_key: "worker_id", dependent: :destroy # 作業員の応募
  has_many :given_reviews, class_name: "Review", foreign_key: "reviewer_id", dependent: :destroy
  has_many :received_reviews, class_name: "Review", foreign_key: "reviewee_id", dependent: :destroy

  # バリデーション
  with_options presence: true do
    validates :role, inclusion: { in: ["owner", "worker"] } # ユーザーの役割（依頼者 or 作業員）のみ許可
    validates :name, length: { maximum: 50 } # ユーザー名は最大50文字まで
    validates :experience, length: { maximum: 300 } # 経験・スキルは最大300文字まで
  end

  ROLE_OPTIONS = {
    "owner" => "依頼者",
    "worker" => "作業員"
  }

  # 役割を日本語で取得
  def role_label
    ROLE_OPTIONS[role] || "不明"
  end

  # 平均評価を取得するメソッド
  def average_rating
    received_reviews.average(:rating) || 0.0
  end
end