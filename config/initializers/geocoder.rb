Geocoder.configure(
  lookup: :google,  # Google APIを使用
  api_key: ENV["GOOGLE_MAPS_API_KEY"],  # 環境変数からAPIキーを取得
  use_https: true,  # HTTPSを使用
  timeout: 5,       # タイムアウト時間（秒）
  units: :km,       # 距離の単位（km）
  cache: Redis.new, # キャッシュ（Redisを使用する場合）
  cache_prefix: "geocoder:" # キャッシュのキー
)