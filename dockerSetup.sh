# 古いバージョンの削除
# 念のため、競合する可能性がある古いパッケージを削除しておきます。
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Docker公式リポジトリのセットアップ
# OS標準のレジストリではなく、常に最新の安定版を受け取れるようDocker公式のリポジトリを登録します。

# パッケージ情報の更新と必須ツールの導入
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg

# 公式GPG鍵の追加（セキュリティ用）
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# リポジトリの登録
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update


# Docker Engineのインストール
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 確認コマンド
sudo docker run hello-world
# 「Hello from Docker!」と表示されれば成功です。


# ユーザー権限の設定（重要）
# デフォルトでは sudo を付けないと docker コマンドが使えません。これを自分のユーザーだけで使えるようにします。
# 自分のユーザーをdockerグループに追加
sudo usermod -aG docker $USER
# この設定を反映させるには、一度ログアウトして再ログインするか、サーバーを再起動する必要があります。反映後は docker ps などが sudo なしで動くようになります。

# 自動起動の設定
# サーバーを再起動した際に、Dockerサービスが自動で立ち上がるようにします。
sudo systemctl enable docker.service
sudo systemctl enable containerd.service




メンテナンスのベストプラクティス
前回の「バージョン固定」の話に関連して、Linuxサーバーでの運用アドバイスです。

アップデートの方法:
sudo apt-get update && sudo apt-get upgrade を実行すれば、Docker Engine自体は最新の安定版に更新されます。

コンテナ内のGemini CLIの更新:
前述の通り、Dockerfile で node:20-slim のようにメジャーバージョンを固定していれば、以下の2ステップで「安全な最新化」が完了します。

Bash
docker pull node:20-slim
docker build -t my-gemini-cli .