# tbt-app

Rails 8 + Ruby 4 + MySQL + Docker 開発環境

## 技術スタック

| 項目 | バージョン |
|------|-----------|
| Ruby | 4.0.5 |
| Rails | 8.1 |
| DB | MySQL 8.4 |
| フロント | Hotwire (Turbo + Stimulus) + Tailwind CSS |
| 認証 | Rails 8 標準 authentication generator |
| 言語 | 日本語（i18n、デフォルトロケール `ja`） |

Hotwire は Rails 7 以降の標準構成です。SPA フレームワークなしで、Turbo による高速なページ遷移と Stimulus による軽量な JavaScript 拡張が使えます。

## 認証（ログイン）

| 項目 | 値 |
|------|-----|
| ログイン URL | http://localhost:3000/session/new |
| 新規登録 URL | http://localhost:3000/registration/new |
| デモユーザー | `demo@example.com` |
| パスワード | `password` |

```bash
# デモユーザーを再作成
docker compose exec web bin/rails db:seed
```

## 前提条件

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) がインストール済みであること

ローカルに Ruby や MySQL をインストールする必要はありません。

## 起動方法

```bash
# 初回・Gemfile 変更時
docker compose build

# DB + Rails サーバー起動
docker compose up
```

ブラウザで http://localhost:3000 を開いてください。

## よく使うコマンド

```bash
# Rails コンソール
docker compose exec web bin/rails console

# マイグレーション
docker compose exec web bin/rails db:migrate

# テスト実行
docker compose exec web bin/rails test

# 新しい gem を追加した後
docker compose build web
docker compose up
```

## MySQL への接続（ホストから）

| 項目 | 値 |
|------|-----|
| Host | 127.0.0.1 |
| Port | 3307 |
| User | root |
| Password | password |
| Database | tbt_app_development |

## ディレクトリ構成（Docker 関連）

- `Dockerfile.dev` — 開発用イメージ（Ruby 4.0.5 + MySQL クライアント）
- `Dockerfile` — 本番用イメージ（Kamal デプロイ用、Rails 標準生成）
- `docker-compose.yml` — 開発環境（web + db）

## 本番デプロイ

Rails 8 には [Kamal](https://kamal-deploy.org/) が同梱されています。設定は `config/deploy.yml` を参照してください。
