# Memorandum

個人的なメモを取るためのリポジトリです。

## 使い方

### 必要なファイル

`conf.yml`というファイルに`username`と`password`をいれときます。
※めんどくさい場合は`config.ru`のbasic認証部分を書き換えます。

ログを保存するbranchを設定するには、`conf.yml`の`branch`をいれておきます。
勝手にbranchを作ってくれるかは確認していないので`git checkout -b log`などとしておいてください。

```yaml
auth:
  username: foo
  password: bar
git:
  branch: log
```

### とりあえず立ち上げる

```console
$ bundle install --path vendor
$ bundle exec rackup
```

### nginxとかでがんばる

unicornいれたので多分以下で動くはず。

```console
$ bundle exec unicorn -c config/unicorn.rb -D
```

## GitHubとの同期方法

gitのhookを利用しようと思ったけど、gollumから更新すると何故か動いてくれないのでcronかwheneverあたりで頑張る予定。

以下のコードを1時間とぐらいに走らせればとりあえず動くには動く。
ロジックもへったくれも無いけど動けば良しとしよう。

```rb
require 'git'

PATH = File.join(File.dirname(__FILE__), "..")
repo = Git.open(PATH)
repo.push(repo.remote('origin'))
```
