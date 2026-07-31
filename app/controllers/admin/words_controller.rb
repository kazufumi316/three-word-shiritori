class Admin::WordsController < Admin::ApplicationController
  before_action :set_word, only: [:edit, :update, :destroy]

  def index
    @row = KanaMatcher::ROWS.key?(params[:row]) ? params[:row] : "あ"
    @words = Word.all
                 .select { |word| KanaMatcher.row_for(word.word_name[0]) == @row }
                 .sort_by { |word| [word.status_before_type_cast, word.word_name] }
  end

  def edit
  end

  def update
    if @word.update(word_params)
      redirect_to admin_words_path, notice: "単語を更新しました"
    else
      render :edit
    end
  end

  def destroy
    @word.destroy
    redirect_to admin_words_path, notice: "単語を削除しました"
  end

  private

  def set_word
    @word = Word.find(params[:id])
  end

  def word_params
    params.require(:word).permit(:word_explanation, :status)
  end
end
