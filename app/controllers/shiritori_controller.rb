class ShiritoriController < ApplicationController
  before_action :authenticate_user!

  KANA_WORD_REGEX = /\A[ぁ-んー]{3}\z/

  def index
    @turn = session[:turn]
    @last_word = session[:last_word]
    @used_words = session[:used_words]
    @required_kana = KanaMatcher.required_starting_kana(@last_word)
    @cpu_comment = CpuResponder.line_for("start")
  end

  def answer
    word = params[:word].to_s.unicode_normalize(:nfc)

    @error = judge(word)

    if @error.nil?
      Word.find_or_create_by!(word_name: word) { |w| w.status = :pending }

      if word[-1] == "ん"
        @result = :lose
        @cpu_comment = CpuResponder.line_for("cpu_win")
        session[:used_words] << word
        session[:last_word] = word
      else
        turn_completed = session[:turn]
        session[:used_words] << word
        session[:last_word] = word

        cpu_word = CpuResponder.select_word(
          required_kana: KanaMatcher.required_starting_kana(word),
          used_words: session[:used_words],
          turn: turn_completed,
        )

        if cpu_word.nil?
          @result = :win
          @cpu_comment = CpuResponder.line_for("user_win")
        else
          @cpu_word = cpu_word.word_name
          session[:used_words] << cpu_word.word_name
          session[:last_word] = cpu_word.word_name
          session[:turn] += 1

          if cpu_word.word_name[-1] == "ん"
            @result = :win
            @cpu_comment = CpuResponder.line_for("user_win")
          else
            @cpu_comment = CpuResponder.aizuchi(turn_completed)
          end
        end
      end
    end

    @turn = session[:turn]
    @last_word = session[:last_word]
    @used_words = session[:used_words]
    @required_kana = KanaMatcher.required_starting_kana(@last_word)
    render :index
  end

  private

  def judge(word)
    return "ことばを いれてね" if word.blank?
    return "ひらがなで3もじ いれてね" unless word.match?(KANA_WORD_REGEX)

    required_kana = KanaMatcher.required_starting_kana(session[:last_word])
    return "「#{required_kana}」から はじまる ことばを いれてね" if KanaMatcher.seion(word[0]) != required_kana
    return "もう つかった ことばだよ" if session[:used_words].include?(word)
    return "その ことばは つかえないよ" if Word.find_by(word_name: word)&.rejected?

    nil
  end
end
