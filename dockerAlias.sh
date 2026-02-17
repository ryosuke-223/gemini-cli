# 毎回長い docker run コマンドを打つのは面倒なので、Linuxのシェル（bashやzsh）にエイリアスを登録しておくと、普通のコマンドのように使えます
# ~/.bashrc または ~/.zshrc に以下を追記します：
alias gemini='docker run -it --rm -v ~/.gemini-config:/root/.config/gemini-cli -v $(pwd):/app my-gemini-cli'

# ※ -v $(pwd):/app を追加することで、**今いるディレクトリのファイルをGeminiに読み込ませる（@file）**ことができるようになります。

# 追記後、設定を反映させます：
source ~/.bashrc

# これで、次からはサーバー上で gemini と打つだけで、仮想環境上のGeminiが起動します。

# Gemini CLIを最新にしたい場合は、以下の2ステップだけで済みます。OS側のパッケージ管理（aptやyum）を汚すことは一切ありません。
docker build --no-cache -t my-gemini-cli . （再ビルド）
# 古いイメージを削除（必要に応じて）