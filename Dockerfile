# 軽量なNode.jsイメージを使用
FROM node:20-slim

# 作業ディレクトリの設定
WORKDIR /app

# Gemini CLIのインストール
RUN npm install -g @google/gemini-cli

# ログイン情報（認証キャッシュ）を保持するためのボリューム設定
# これによりコンテナを消しても再ログインが不要になる
VOLUME /root/.config/gemini-cli

# コンテナ起動時にGeminiを立ち上げる
ENTRYPOINT ["gemini"]