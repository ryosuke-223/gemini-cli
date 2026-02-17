# nodeのVer20の最新イメージを取得してくる（壊れない範囲で最新化）
docker pull node:20-slim

# 最新イメージを利用してGeminiを利用できるDockerイメージをビルドする
docker build -t my-gemini-cli .
