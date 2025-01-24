Rails.application.routes.draw do
  devise_for :users
  root "job_posts#index"# ルートページを募集一覧に設定

  # 作業員募集機能
  resources :job_posts, only: [:index, :show, :new, :create] do
    resources :applications, only: [:create] # 応募処理は job_post にネスト
  end
end
