#!/usr/bin/env bash
set -e

echo "マイグレーション実行中..."
bundle exec rails db:migrate

if [ "${SEED_ON_BOOT}" = "true" ]; then
  echo "== db:seed 実行 =="
  bundle exec rails db:seed
  echo "== db:seed 完了 =="
else
  echo "seedはスキップ（SEED_ON_BOOT=true のときだけ実行）"
fi

echo "アプリ起動"
exec bundle exec puma -C config/puma.rb