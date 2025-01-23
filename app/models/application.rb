class Application < ApplicationRecord
  belongs_to :job_post
  belongs_to :worker, class_name: "User"
end