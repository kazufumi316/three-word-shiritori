# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# MeCab単体解析だと複数形態素に分割されてしまい誤って弾かれる、実在する3文字ひらがな名詞
%w[
  しょう にしん しない ひとで あるじ からだ どこか しよう いくさ じゃま
  がんも ねどこ ばった えじき つらさ あいま あまた ひどさ なにわ かやの
  のどか ひそう あらわ みだら めいよ かって ふそん いこじ うかつ しれつ
].each do |word_name|
  Word.find_or_create_by!(word_name: word_name)
end
