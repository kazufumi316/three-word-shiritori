class UsersController < ApplicationController
  STARTING_KANA = %w[あ か さ た な は ま や ら わ].freeze

  before_action :authenticate_user!, only: [:destroy, :restart]

  # ゲストログイン開始（レベル選択画面のボタンの遷移先）
  def create
    level = Level.valid?(params[:level]) ? params[:level] : Level::DEFAULT
    user = User.create_guest!
    sign_in(user)
    reset_shiritori_session(level)
    redirect_to shiritori_path
  end

  # 終了ボタン：ゲストユーザーのログアウト＋destroy
  def destroy
    user = current_user
    sign_out(user)
    user.destroy
    reset_shiritori_session
    redirect_to root_path
  end

  # もう1回ボタン：destroy → 新規ゲストユーザー作成 → sign_inを一連の流れで実行（レベルは直前の対局を引き継ぐ）
  def restart
    old_user = current_user
    level = session[:level] || Level::DEFAULT
    sign_out(old_user)
    old_user.destroy

    new_user = User.create_guest!
    sign_in(new_user)
    reset_shiritori_session(level)
    redirect_to shiritori_path
  end

  private

  def reset_shiritori_session(level = Level::DEFAULT)
    session[:turn] = 1
    session[:used_words] = []
    session[:last_word] = STARTING_KANA.sample
    session[:level] = level
  end
end
