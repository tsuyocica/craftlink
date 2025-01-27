class JobPost < ApplicationRecord
  # アソシエーション
  belongs_to :owner, class_name: "User"
  has_many   :job_applications, dependent: :destroy

  #バリデーション
  with_options presence: true do
    validates :title,       length: { maximum: 100 } # 募集タイトルは最大100文字まで
    validates :description, length: { maximum: 1_000 } # 作業内容の詳細は最大1000文字まで
    validates :num_workers, numericality: { greater_than: 0, less_than_or_equal_to: 10 } # 募集人数は1人以上、10人以下
    validates :location,    length: { maximum: 255 } # 作業場所の住所は最大255文字まで
    validates :pay_amount,  numericality: { greater_than: 3_000 } # 報酬額は3000円以上
    validates :pay_type,    inclusion: { in: ["hourly", "daily", "fixed"] } # 支払い方法は「時給」「日給」「固定給」のみ許可
  end

  validates :status, inclusion: { in: ["open", "closed", "filled"] } # 募集のステータスは「募集中」「締切」「成立」のみ許可

  # 🔹 スコープ（現在募集中の案件のみを取得）
  scope :opened, -> { where(status: "open") }

  # ステータス（英語 → 日本語）
  STATUS_OPTIONS = {
    "open"   => "募集中",
    "closed" => "締切",
    "filled" => "成立"
  }

  # 支払い方法（英語 → 日本語）
  PAY_TYPE_OPTIONS = {
    "hourly" => "時給",
    "daily"  => "日給",
    "fixed"  => "固定給"
  }

  def status_label
    STATUS_OPTIONS[status] || "不明"
  end

  def pay_type_label
    PAY_TYPE_OPTIONS[pay_type] || "不明"
  end
end