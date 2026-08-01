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

  あひる あさひ あかり
  いのち いなか いかり
  うちわ うさぎ うわさ うでわ
  えがお えもの えいが
  おかし おかね おとな おふろ おなか
  たいこ たまご たから たわし たぬき
  ちから ちしき ちいき ちかく ちょう
  つばさ つくえ つなみ つばめ つきみ
  てあし てんき てすり てじな
  とかげ とけい とうふ とかい
  なみだ なかま ながし なまえ
  にもつ にがて にちじ
  ぬりえ ぬのじ ぬいめ
  ねいろ ねまき
  のはら のうか のぞみ のろし
  はさみ はたけ はなび はしご
  ひかり ひろば ひみつ
  ふくろ ふたご ふもと ふうふ
  へいわ へんじ へんぴ へいち へきち
  ほたる ほうき ほくろ ほうび
  まくら まほう まいご まつり まんが
  みどり みなと みぶり
  むかし むすめ むかで むしば むすこ
  めがね めだま めいし めばえ
  もみじ もくば もぐら もちや もんく
  やさい やおや やなぎ
  ゆびわ ゆかた ゆのみ ゆかい ゆうひ
  ようき よあけ よみち よそく よぼう
  らくだ らいう らくご らいぶ らくば
  りんご りゆう りかい りそう
  るーる るびー るっく
  れきし れんが れいぎ れいか れんげ
  ろうか ろくが ろしあ ろーど ろくろ
  わかめ わがし わなげ わたし わかば
  こおり こくご ことり こねこ
  きつね きもち きせつ きろく
  くじら くるま くもり くすり
  けしき けいこ けむり けいと けつい
  さかな さくら さいふ さとう
  すいか すずめ すもう すなば すきま すすき
  せかい せなか せいと せいざ せびろ せんす
  そうじ そくど そうこ そなえ そぼく
].each do |word_name|
  word = Word.find_or_initialize_by(word_name: word_name)
  word.update!(status: :approved)
end

# 「ん」で終わる語(10ターン目以降、CPUが該当する頭文字のとき優先的に選んで対局を終わらせるための語)
%w[
  いけん うどん えほん かばん きけん こばん さかん しけん てほん にほん
  ふとん みかん りねん れもん おかん くかん ちきん ねはん ほかん やかん
  たにん ねだん もめん やちん らせん ろてん やきん
].each do |word_name|
  word = Word.find_or_initialize_by(word_name: word_name)
  word.update!(status: :approved)
end

[
  { comment_body: "おねがいします", category: "start" },
  { comment_body: "まけました", category: "user_win" },
  { comment_body: "やった", category: "cpu_win" },
  { comment_body: "ありがとうございました", category: "ending" },
  { comment_body: "またきてね", category: "ending" },
].each do |attrs|
  CpuComment.find_or_create_by!(comment_body: attrs[:comment_body]) do |comment|
    comment.category = attrs[:category]
  end
end
