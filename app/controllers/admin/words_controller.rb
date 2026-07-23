class Admin::WordsController < Admin::ApplicationController
  before_action :set_word, only: [:edit, :update, :destroy]

  def index
    @words = Word.all
  end

  def edit
  end

  def update
    if @word.update(word_params)
      redirect_to admin_words_path, notice: "説明文を更新しました"
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
    params.require(:word).permit(:word_explanation)
  end
end
