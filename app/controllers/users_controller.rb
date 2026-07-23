class UsersController < ApplicationController
  # ゲストログイン開始（トップページの「げーむかいし」ボタンの遷移先）
  # 実装は#14 ログイン機能実装で行う
  def create
  end

  # 終了ボタン：ゲストユーザーのログアウト＋destroy
  # 実装は#15 ログアウト機能実装で行う
  def destroy
  end

  # もう1回ボタン：destroy → 新規ゲストユーザー作成 → sign_inを一連の流れで実行
  # 実装は#15 ログアウト機能実装で行う
  def restart
  end
end
