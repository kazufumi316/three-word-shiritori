class UsersController < ApplicationController
  STARTING_KANA = %w[あ か さ た な は ま や ら わ].freeze

  before_action :authenticate_user!, only: [:destroy, :restart]

  # ゲストログイン開始（トップページの「げーむかいし」ボタンの遷移先）
  def create
    user = User.create_guest!
    sign_in(user)
    reset_shiritori_session
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

  # もう1回ボタン：destroy → 新規ゲストユーザー作成 → sign_inを一連の流れで実行
  def restart
    old_user = current_user
    sign_out(old_user)
    old_user.destroy

    new_user = User.create_guest!
    sign_in(new_user)
    reset_shiritori_session
    redirect_to shiritori_path
  end

  private

  def reset_shiritori_session
    session[:turn] = 1
    session[:used_words] = []
    session[:last_word] = STARTING_KANA.sample
  end
end
