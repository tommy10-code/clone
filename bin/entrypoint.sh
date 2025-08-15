#!/usr/bin/env bash
set -e

# この下にやりたいコマンドを書く
echo "マイグレーション実行中..."
bundle exec rails db:migrate

echo "必要ならseed実行..."
bundle exec rails db:seed

echo "アプリ起動"
exec bundle exec puma -C config/puma.rb