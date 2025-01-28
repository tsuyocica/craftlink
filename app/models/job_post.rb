class JobPost < ApplicationRecord
  # アソシエーション
  belongs_to :owner, class_name: "User"
  has_many   :job_applications, dependent: :destroy

  # バリデーション
  with_options presence: true do
    validates :work_title,       length: { maximum: 100 } # 募集タイトルは最大100文字まで
    validates :work_description, length: { maximum: 1_000 } # 作業内容の詳細は最大1000文字まで
    validates :num_workers, numericality: { greater_than: 0, less_than_or_equal_to: 10 } # 募集人数は1〜10人
    validates :work_location,    length: { maximum: 255 } # 作業場所の住所は最大255文字まで
    validates :work_latitude,    numericality: true # 緯度（数値であること）
    validates :work_longitude,   numericality: true # 経度（数値であること）
    validates :work_pay_amount,  numericality: { greater_than_or_equal_to: 3_000, less_than_or_equal_to: 500_000 } # 報酬額は3,000円〜500,000円
    validates :work_pay_type,    inclusion: { in: ["hourly", "daily", "fixed"] } # 支払い方法は「時給」「日給」「固定給」のみ許可
  end

  validates :work_status, inclusion: { in: ["opening", "closed"] } # 募集のステータスは「募集中」「受付終了」のみ許可

  # 作業終了日は作業開始日以降である必要がある
  validate :end_date_after_start_date
  validate :end_time_after_start_time

  # Google Maps のジオコーディング（住所から緯度経度を取得）
  before_validation :geocode_address, if: -> { work_location.present? && (work_latitude.nil? || work_longitude.nil?) }

  # ステータス（英語 → 日本語）
  STATUS_OPTIONS = {
    "opening"   => "募集中",
    "closed" => "受付終了"
  }

  # 支払い方法（英語 → 日本語）
  PAY_TYPE_OPTIONS = {
    "hourly" => "時給",
    "daily"  => "日給",
    "fixed"  => "固定給"
  }

  # 日本語のステータスラベルを取得
  def status_label
    STATUS_OPTIONS[work_status] || "不明"
  end

  # 日本語の支払い方法ラベルを取得
  def pay_type_label
    PAY_TYPE_OPTIONS[work_pay_type] || "不明"
  end

  private

  # 作業終了日は作業開始日以降である必要がある
  def end_date_after_start_date
    return if work_start_date.nil? || work_end_date.nil?
    errors.add(:work_end_date, "は開始日以降に設定してください") if work_end_date < work_start_date
  end

  # 作業終了時刻は作業開始時刻以降である必要がある
  def end_time_after_start_time
    return if work_start_time.nil? || work_end_time.nil? || work_start_date != work_end_date
    errors.add(:work_end_time, "は開始時刻以降に設定してください") if work_end_time <= work_start_time
  end

  # 住所から緯度経度を取得
  def geocode_address
    results = Geocoder.search(work_location)
    if results.present?
      self.work_latitude = results.first.latitude
      self.work_longitude = results.first.longitude
    else
      errors.add(:work_location, "の位置情報を取得できませんでした")
    end
  end
end