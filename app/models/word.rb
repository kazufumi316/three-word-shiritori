class Word < ApplicationRecord
  KANA_ONLY_REGEX = /\A[ぁ-んー]+\z/

  validates :word_name, presence: true, uniqueness: true,
                         format: { with: KANA_ONLY_REGEX, message: "はひらがなのみで入力してください" }
end
