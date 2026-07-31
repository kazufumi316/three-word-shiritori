class Word < ApplicationRecord
  KANA_ONLY_REGEX = /\A[ぁ-んー]+\z/

  enum status: { pending: 0, approved: 1, rejected: 2 }

  validates :word_name, presence: true, uniqueness: true,
                         format: { with: KANA_ONLY_REGEX, message: "はひらがなのみで入力してください" }
end
