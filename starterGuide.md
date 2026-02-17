この手順では、Docker を活用することで Node.js などのランタイムを直接インストールせず、環境のポータビリティとクリーンさを両立させています。

Linux環境における Gemini CLI 構築ガイド (Docker運用版)
本資料では、WindowsユーザーがLinuxサーバー（Ubuntu/Debian系を想定）において、環境をクリーンに保ちながら Gemini CLI を導入・運用する手順をまとめます。

1. Docker Engine のセットアップ（事前準備）
Linux標準のパッケージはバージョンが古いため、Docker公式リポジトリを利用して最新版をインストールします。

1.1 必須ツールの導入とリポジトリ登録
セキュリティ（GPG鍵）を担保しながら、公式リポジトリをシステムに認識させます。

Bash
# 1. パッケージリストの更新とツールの導入
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

# 2. Docker公式GPG鍵の追加（セキュリティ認証用）
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# 3. リポジトリの登録
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 4. 再度リストを更新
sudo apt-get update
1.2 インストールと権限設定
Bash
# Docker本体のインストール
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# sudoなしで実行できるようにユーザーをグループに追加
sudo usermod -aG docker $USER
重要: usermod 実行後は、一度ログアウトして再ログインするか、サーバーを再起動することで設定が反映されます。

2. Gemini CLI 仮想環境の構築
Dockerを使用して、Node.js環境をコンテナ内に閉じ込めます。

2.1 Dockerfile の作成
適当な作業ディレクトリ（例: ~/gemini-setup）を作成し、以下の内容で Dockerfile を保存します。

Dockerfile
# メジャーバージョンを固定（安定性と最新パッチの両立）
FROM node:20-slim

WORKDIR /app

# Gemini CLIのインストール
RUN npm install -g @google/gemini-cli

# 認証情報の永続化用ボリューム
VOLUME /root/.config/gemini-cli

ENTRYPOINT ["gemini"]
2.2 イメージのビルド
Bash
docker build -t my-gemini-cli .
3. 運用設定（エイリアスの登録）
毎回長いDockerコマンドを打つのを避けるため、エイリアスを設定します。これにより、あたかもLinuxに直接インストールされているかのように振る舞います。

~/.bashrc（または使用しているシェルの設定ファイル）の末尾に以下を追記します。

Bash
# エイリアス設定
# -v $(pwd):/app により、現在のディレクトリのファイルを読み込み可能にする
alias gemini='docker run -it --rm -v ~/.gemini-config:/root/.config/gemini-cli -v $(pwd):/app my-gemini-cli'
反映コマンド：

Bash
source ~/.bashrc
4. 初回起動と認証
ターミナルで gemini と入力。

Login with Google を選択。

表示された URL を手元のWindowsブラウザで開き、Googleログイン。

発行された Authorization Code をLinuxのターミナルに貼り付け。

5. メンテナンス（アップデート・削除）
アップデート（ベストプラクティス）
Node.js 20系の最新パッチを適用しつつ、Gemini CLIを最新にする手順：

Bash
docker pull node:20-slim
docker build --no-cache -t my-gemini-cli .
環境の完全削除
システムを一切汚していないため、以下のステップで跡形もなく消去可能です。

エイリアスの削除（.bashrc から消す）

コンテナイメージの削除：docker rmi my-gemini-cli

認証情報の削除：rm -rf ~/.gemini-config

Next Step: > これで準備は完了です。まずは gemini と打ち込んで、サーバー上の設定ファイルを読み込ませる（例： >> @docker.list このファイルの内容を解説して）ことから始めてみませんか？


参照
- https://www.silicloud.com/ja/blog/debian%E3%81%A7docker%E3%82%92%E3%82%A4%E3%83%B3%E3%82%B9%E3%83%88%E3%83%BC%E3%83%AB%E3%81%99%E3%82%8B%E6%96%B9%E6%B3%95%E3%81%AF%EF%BC%9F/
- https://zenn.dev/take64/articles/360c39899e53ff
- https://gemini.google.com/app/234be3d092b0b580?utm_source=app_launcher&utm_medium=owned&utm_campaign=base_all