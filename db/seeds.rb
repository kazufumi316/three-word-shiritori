# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# 管理者が承認済みとして最初から登録しておく3文字ひらがな名詞
%w[
  しょう にしん しない ひとで あるじ からだ どこか しよう いくさ じゃま
  がんも ねどこ ばった えじき つらさ あいま あまた ひどさ なにわ かやの
  のどか ひそう あらわ みだら めいよ かって ふそん いこじ うかつ しれつ
  こいぬ
].each do |word_name|
  Word.find_or_create_by!(word_name: word_name) { |word| word.status = :approved }
end

# 「ん」で終わる語(10ターン目以降、CPUが該当する頭文字のとき優先的に選んで対局を終わらせるための語)
%w[
  いけん うどん えほん かばん きけん こばん さかん しけん てほん にほん
  ふとん みかん りねん れもん おかん くかん ちきん ねはん ほかん やかん
].each do |word_name|
  Word.find_or_create_by!(word_name: word_name) { |word| word.status = :approved }
end

[
  { comment_body: "おねがいします", category: "start", fixed_turn: nil },
  { comment_body: "いいね", category: "aizuchi", fixed_turn: nil },
  { comment_body: "うまい", category: "aizuchi", fixed_turn: nil },
  { comment_body: "どうだ", category: "aizuchi", fixed_turn: nil },
  { comment_body: "おじょうず", category: "aizuchi", fixed_turn: 3 },
  { comment_body: "まけました", category: "user_win", fixed_turn: nil },
  { comment_body: "やった", category: "cpu_win", fixed_turn: nil },
  { comment_body: "ありがとうございました", category: "ending", fixed_turn: nil },
  { comment_body: "またきてね", category: "ending", fixed_turn: nil },
].each do |attrs|
  CpuComment.find_or_create_by!(comment_body: attrs[:comment_body]) do |comment|
    comment.category = attrs[:category]
    comment.fixed_turn = attrs[:fixed_turn]
  end
end
