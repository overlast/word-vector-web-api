# word-vector-web-api : Implementation in order to operate a web api of word2vec, GloVe and e.t.c. in any environment

## word-vector-web-api とは
word2vec や GloVe などで構築済みな単語ベクトルのモデルを使った結果を HTTP 経由で JSON/JSONP 形式で取得することができる Web API です。

word-vector-web-api を利用することで、様々なライブラリや資源を組み合わせて同様の Web API を構築するために必要な作業コストを軽減できます。

## 特徴
### 利点
- Web API なので結果所得はどのようなプログラミング言語からでも可能
- 結果取得時に JSONP を指定すれば、フロントエンドからの結果取得・可視化も可能
- 結果のキャッシュが可能
    - nginx でおこなっている
- 割と高速、割と省メモリ
    - モデルの読み込み、検索は C++ のサーバでおこなっている

### 欠点
- とくになし

## 使用開始
### 動作に必要なもの

インストール時に以下のライブラリを順にインストールします。

- [nginx-1.8.0](http://nginx.org/) (独自のディレクトリにインストールされます)
- [nginx-msgpack-rpc-module](https://github.com/overlast/nginx-msgpack-rpc-module)
- [word2vec-msgpack-rpc-server](https://github.com/overlast/word2vec-msgpack-rpc-server)
- [MeCab](http://taku910.github.io/mecab/)
- [mecab-ipadic](http://taku910.github.io/mecab/#download)
- [mecab-ipadic-NEologd](https://github.com/neologd/mecab-ipadic-neologd)
- [Word2Vec](http://code.google.com/p/word2vec/) (word-vector-web-api ディレクトリ内にインストールされます)

動作に必要なものは、上記ライブラリのインストール時に必要としている資源やライブラリです。

### word-vector-web-api をインストールする準備

更新は GitHub 経由で行います。

初回は以下のコマンドでgit cloneしてください。

    $ git clone --depth 1 https://github.com/overlast/word-vector-web-api.git

または

    $ git clone --depth 1 git@github.com:overlast/word-vector-web-api.git

もしも、リポジトリの全変更履歴を入手したい方は「--depth 1」を消してcloneして下さい。

### word-vector-web-api のインストール/更新
#### Step.1
上記の準備でcloneしたリポジトリに移動します。

    $ cd word-vector-web-api

#### Step.2
以下のコマンドを実行するとインストール、または、上書きによる最新版への更新ができます。

    $ ./bin/word-vector-web-api -n

インストール先はオプション未指定の場合 /use/local 以下に作成したフォルダになります。

任意の path にインストールしたい場合や、user 権限でインストールする際のオプションなどは以下で確認できます。

    $ ./bin/install-word-vector-web-api -h

### word-vector-web-api の使用例
word-vector-web-api を使いたいときは、自分の作成したいアプリケーションごとに conf ファイルをコピーして設定を調整して使うのが良いです。

以下では日本語 Wikipedia を使って作ったサンプルモデルを使ってデータを取得するための手順を書きます。

#### Step1. サンプルモデルのダウンロード
以下のモデルファイルをダウンロードして、word-vector-web-api/model 以下にコピーして下さい。

- [jawiki.20150602.neologd.bin.xz (810MByte)](https://drive.google.com/file/d/0B5QYYyltotqfM2lRQ3l4Mkc5Mk0/view?usp=sharing)
    - 日本語 Wikipedia のdumpデータ(jawiki-latest-pages-articles.xml.bz2)から作成
    - jawiki-latest-pages-articles.xml.bz2 から plain text を抽出する際に New Version の [WikiExtractor.py](https://svn.code.sf.net/p/apertium/svn/trunk/apertium-tools/WikiExtractor.py) を使用
        - http://wiki.apertium.org/wiki/Wikipedia_Extractor
    - 分かち書きに MeCab と mecab-ipadic-NEologd を使用
    - Word2Vec のパラメタは"-cbow 0 -size 300 -window 5 -negative 0 -hs 1 -sample 1e-5"

#### Step2. サンプルモデルの解凍
word-vector-web-api/model 以下にコピーしたモデルファイルを解凍します。

    $ cd word-vector-web-api
    $ unxz model/jawiki.20150602.neologd.bin.xz
    $ ls -al model
    -rw-rw-r--  1 overlast overlast  917846510  6月 28 11:27 2015 jawiki.20150602.neologd.bin

#### サンプルの実行例 (CentOS 上でインストールした場合)
日本語 Wikipedia のダンプデータから決め打ちのパラメタで作成されたモデルをダウンロードして起動します。

    $ cd word-vector-web-api
    $ bin/get-ja-wikipedia-word-vector.sh (今書いてる)
    $ bin/boot-word-vector-api.sh (今書いてる)

## Word Vector Web API の実行結果の例
### mecab-ipadic-neologd をシステム辞書として使った場合
    nyan (今書いてる)

#### どこに効果が出ている?
    wan (今書いてる)

### 標準のシステム辞書(ipadic-2.7.0)を使った場合
    gaoh (今書いてる)

## 今後の発展
継続して開発しますので、気になるところはどんどん改善されます。

ユーザの8割が気になる部分を優先して改善します。

## Bibtex

もしも mecab-ipadic-NEologd を論文から参照して下さる場合は、以下の bibtex をご利用ください。

    @misc{sato2015wordvectorwebapi,
        title  = {Word Vector Web API},
        author = {Toshinori, Sato},
        url    = {https://github.com/overlast/word-vector-web-api},
        year   = {2015}
    }

## Copyrights
Copyright (c) 2015 Toshinori Sato (@overlast) All rights reserved.

ライセンスは Apache License, Version 2.0 です。下記をご参照下さい。

- https://github.com/overlast/word-vector-web-api/blob/master/COPYING
