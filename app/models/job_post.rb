class JobPost < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_many   :job_applications, dependent: :destroy
end