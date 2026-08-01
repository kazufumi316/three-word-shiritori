class ShiritoriController < ApplicationController
  before_action :authenticate_user!

  KANA_WORD_REGEX = /\A[ぁ-んー]{3}\z/

  def index
    @turn = session[:turn]
    @last_word = session[:last_word]
    @used_words = session[:used_words]
    @required_kana = KanaMatcher.required_starting_kana(@last_word)

    result = session.delete(:last_answer_result)

    if result
      @error = result["error"]
      @result = result["result"]&.to_sym
      @cpu_word = result["cpu_word"]
      @cpu_comment_body = result["cpu_comment_body"]
    else
      @cpu_comment_body = CpuResponder.line_for("start")&.comment_body
    end
  end

  def answer
    word = params[:word].to_s.unicode_normalize(:nfc)

    error = judge(word)
    result = { "error" => error }

    if error.nil?
      Word.find_or_create_by!(word_name: word) { |w| w.status = :pending }

      if word[-1] == "ん"
        result["result"] = "lose"
        result["cpu_comment_body"] = CpuResponder.line_for("cpu_win")&.comment_body
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
          finish_from_turn: Level.finish_from_turn(session[:level]),
        )

        if cpu_word.nil?
          result["result"] = "win"
          result["cpu_comment_body"] = CpuResponder.line_for("user_win")&.comment_body
        else
          result["cpu_word"] = cpu_word.word_name
          session[:used_words] << cpu_word.word_name
          session[:last_word] = cpu_word.word_name
          session[:turn] += 1

          if cpu_word.word_name[-1] == "ん"
            result["result"] = "win"
            result["cpu_comment_body"] = CpuResponder.line_for("user_win")&.comment_body
          end
        end
      end
    end

    session[:last_answer_result] = result
    redirect_to shiritori_path
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
