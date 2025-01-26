class JobApplication < ApplicationRecord
  # アソシエーション
  belongs_to :job_post
  belongs_to :worker, class_name: "User"

  # 🔹 デフォルト値の設定（status が nil の場合は "pending" にする）
  before_validation :set_default_status, on: :create

  # バリデーション
  with_options presence: true do
    validates :message, length: { maximum: 500 } # 応募メッセージは最大500文字まで
  end

  validates :status, inclusion: { in: ["pending", "approved", "rejected", "confirmed"] } # 応募のステータスは「応募中」「承認」「却下」「確定」のみ許可
  validates :worker_id, uniqueness: { scope: :job_post_id, message: "既に応募済みです" } # 同じ作業員が同じ募集に2回応募できないようにする

  # ステータス（英語 → 日本語）
  STATUS_OPTIONS = {
    "pending"   => "応募中",
    "approved"  => "承認",
    "rejected"  => "却下",
    "confirmed" => "確定"
  }

  def status_label
    STATUS_OPTIONS[status] || "不明"
  end

  private

  # 🔹 ステータスのデフォルト値を設定
  def set_default_status
    self.status ||= "pending"
  end
end