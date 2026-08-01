class CpuResponder
  def self.line_for(category)
    CpuComment.where(category: category).sample
  end

  # wordsテーブルの中からCPUが続けられる語を選ぶ。見つからなければnil(CPUの まけ)
  # finish_from_turn以降は「ん」で終わる語があれば必ずそれを選び対局を終わらせる(なければそのまま まけ)
  def self.select_word(required_kana:, used_words:, turn:, finish_from_turn:)
    candidates = Word.approved.where.not(word_name: used_words).select do |word|
      KanaMatcher.seion(word.word_name[0]) == required_kana
    end

    if turn >= finish_from_turn
      return candidates.find { |word| word.word_name[-1] == "ん" }
    end

    return nil if candidates.empty?

    non_finishers = candidates.reject { |word| word.word_name[-1] == "ん" }
    (non_finishers.presence || candidates).sample
  end
end
