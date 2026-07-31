class KanaMatcher
  # 濁点/半濁点つきのかな => 清音
  SEION = {
    "が" => "か", "ぎ" => "き", "ぐ" => "く", "げ" => "け", "ご" => "こ",
    "ざ" => "さ", "じ" => "し", "ず" => "す", "ぜ" => "せ", "ぞ" => "そ",
    "だ" => "た", "ぢ" => "ち", "づ" => "つ", "で" => "て", "ど" => "と",
    "ば" => "は", "び" => "ひ", "ぶ" => "ふ", "べ" => "へ", "ぼ" => "ほ",
    "ぱ" => "は", "ぴ" => "ひ", "ぷ" => "ふ", "ぺ" => "へ", "ぽ" => "ほ",
  }.freeze

  # かな => 段(母音)。「ー」の直前の文字から伸ばす母音を判定するために使う
  VOWEL = {
    %w[あ か さ た な は ま や ら わ が ざ だ ば ぱ] => "あ",
    %w[い き し ち に ひ み り ぎ じ ぢ び ぴ] => "い",
    %w[う く す つ ぬ ふ む ゆ る ぐ ず づ ぶ ぷ] => "う",
    %w[え け せ て ね へ め れ げ ぜ で べ ぺ] => "え",
    %w[お こ そ と の ほ も よ ろ を ご ぞ ど ぼ ぽ] => "お",
  }.each_with_object({}) { |(chars, vowel), h| chars.each { |c| h[c] = vowel } }.freeze

  # 五十音の行。管理画面での単語の絞り込み(ページネーション)に使う
  ROWS = {
    "あ" => %w[あ い う え お],
    "か" => %w[か き く け こ],
    "さ" => %w[さ し す せ そ],
    "た" => %w[た ち つ て と],
    "な" => %w[な に ぬ ね の],
    "は" => %w[は ひ ふ へ ほ],
    "ま" => %w[ま み む め も],
    "や" => %w[や ゆ よ],
    "ら" => %w[ら り る れ ろ],
    "わ" => %w[わ を ん],
  }.freeze

  def self.seion(char)
    SEION.fetch(char, char)
  end

  def self.row_for(char)
    seion_char = seion(char)
    ROWS.find { |_, chars| chars.include?(seion_char) }&.first
  end

  # 「ー」で終わる場合は直前の文字の母音まで戻して次の頭文字を判定する(例: 「るびー」=> 「い」)
  def self.required_starting_kana(word)
    last = word[-1]
    base = last == "ー" ? VOWEL.fetch(word[-2], last) : last
    seion(base)
  end
end
