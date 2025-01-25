class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # アソシエーション
  has_many :job_posts, foreign_key: "owner_id", dependent: :destroy

  # バリデーション
  with_options presence: true do
    validates :role, inclusion: { in: ["owner", "worker"] } # ユーザーの役割（施工主 or 作業員）のみ許可
    validates :name, length: { maximum: 50 } # ユーザー名は最大50文字まで
  end

  validates :rating, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5 } # 評価は0.0〜5.0の範囲

  ROLE_OPTIONS = {
    "owner" => "依頼者",
    "worker" => "作業員"
  }

  def role_label
    ROLE_OPTIONS[role] || "不明"
  end
end