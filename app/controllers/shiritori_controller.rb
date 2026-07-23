class ShiritoriController < ApplicationController
  before_action :authenticate_user!

  KANA_WORD_REGEX = /\A[ぁ-んー]{3}\z/

  def index
    @turn = session[:turn]
    @last_word = session[:last_word]
    @used_words = session[:used_words]
  end

  def answer
    word = params[:word].to_s.unicode_normalize(:nfc)

    @error = judge(word)

    if @error.nil?
      if word[-1] == "ん"
        @result = :lose
      else
        session[:used_words] << word
        session[:last_word] = word
        session[:turn] += 1
      end
    end

    @turn = session[:turn]
    @last_word = session[:last_word]
    @used_words = session[:used_words]
    render :index
  end

  private

  def judge(word)
    return "入力してください" if word.blank?
    return "ひらがな3文字で入力してください" unless word.match?(KANA_WORD_REGEX)
    return "「#{session[:last_word][-1]}」から始まる言葉を入力してください" if word[0] != session[:last_word][-1]
    return "すでに使った言葉です" if session[:used_words].include?(word)
    return "実在する言葉ではないようです" unless WordChecker.real_word?(word) || Word.exists?(word_name: word)

    nil
  end
end
