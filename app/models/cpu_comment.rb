class CpuComment < ApplicationRecord
  CATEGORIES = %w[aizuchi start user_win cpu_win ending].freeze

  validates :comment_body, presence: true
  validates :category, presence: true, inclusion: { in: CATEGORIES }
  validates :fixed_turn, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
end
