class CpuComment < ApplicationRecord
  CATEGORIES = %w[start user_win cpu_win ending].freeze

  validates :comment_body, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }
end
