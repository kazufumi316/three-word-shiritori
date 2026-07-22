# ベースイメージ
FROM ruby:3.3.6


# タイムゾーンの設定
# 今回は日本時間設定
ENV TZ=Asia/Tokyo


# 必要なパッケージのインストール
# Linuxのアップデート及びライブラリの追加
RUN apt-get update -qq && apt-get install -y \

# Gemの翻訳に必要なパッケージの追加
    build-essential \

# PostgreSQLの開発用パッケージの追加
    libpq-dev \

# Node.jsのパッケージの追加
# JavaScriptを使わない場合でもCSSで使う場合があるので入れておいたほうがいい
    nodejs \

# daisyUIの使用のためにNode.jsを管理するためのパッケージ
# npmを使う場合は設定が変わる
    yarn \

# PostgreSQLの操作に必要なパッケージの追加
    postgresql-client \

# 形態素解析(MeCab)本体・辞書・開発用ヘッダの追加
# nattoがFFI経由でlibmecabを呼び出すために必要
    mecab \
    libmecab-dev \
    mecab-ipadic-utf8 && \
# パッケージをインストールして不要なものをキャッシュを削除するコマンド
    rm -rf /var/lib/apt/lists/*

# Node.jsとnpmを公式リポジトリからインストール
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs

# ここを追加することでNode.js標準のCorepackを使ってyarnを有効化することができる
RUN corepack enable


# 作業ディレクトリの指定
WORKDIR /app

# Gemfileのコピー及びインストール
COPY Gemfile Gemfile.lock ./
RUN bundle install

# アプリファイルのコピー
COPY . .

# ポート公開
EXPOSE 3000

# サーバー起動コマンド
# Railsサーバー起動の際に実行するものを選択
CMD ["rails", "server", "-b", "0.0.0.0"]