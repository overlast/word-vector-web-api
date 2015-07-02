# word-vector-web-api : Implementation in order to operate a web api of word2vec, GloVe and e.t.c. in any environment

## word-vector-web-api とは
word2vec や GloVe などで構築済みな単語ベクトルのモデルを使った結果を HTTP 経由で JSON/JSONP 形式で取得することができる Web API です。

word-vector-web-api を利用することで、様々なライブラリや資源を組み合わせて同様の Web API を構築するために必要な作業コストを軽減できます。

## 特徴
### 利点
- Web API なので結果所得はどのようなプログラミング言語からでも可能
- 結果取得時に JSONP を指定すれば、フロントエンドからの結果取得・可視化も可能
- HTTP サーバに nginx を使っており、処理結果がキャッシュされる
- 割と高速、割と省メモリ
    - モデルの読み込みと検索は C++ な MessagePack RPC サーバでおこなっている
- Dockerfile が用意されている
    - アプリケーションごとに ENDPOINT に使うスクリプトを改変して image を作り直せばよい

### 欠点
- サンプルを眺めて理解して、自分のアプリケーションに利用するためには、結局 word-vector-web-api の各コードを読む必要がある

## Docker + サンプルモデルを使って結果を確認
### 事前に用意する必要があるもの
#### Linux

- (登録していない場合) epel リポジトリ

    $ sudo yum -y clean all

    $ sudo yum -y install epel-release

    $ sudo yum -y update

- docker

    $ sudo yum --enablerepo=epel -y install docker-io

- Docker に関する知識
    - docker コマンドで CentOS の docker image を pull して run できる程度に

- Google のアカウント
    - Google Drive からサンプルモデルをダウンロードするために必要です

#### OSX
- [boot2docker](http://boot2docker.io/)
    - パッケージをインストールする

- Docker と boot2docker に関する知識
    - boot2docker を使って CentOS の docker image を pull して run できる程度に

- Google のアカウント
    - Google Drive からサンプルモデルをダウンロードするために必要です

### 手順
#### Step1. サンプルモデルの入手
はじめに以下のコマンドを実行してサンプルモデル(約 800 MByte)を Google Drive からダウンロードします。

    $ ./libexec/download-sample-jawiki-model.sh

上記で実行したスクリプトは、golang で実装された drive コマンドのコンパイルと、それを使った Google Drive に対するリクエストを行います。

たとえば以下の様な出力が表示されます。

    $./libexec/download-sample-jawiki-model.sh
    [sample-model-downloader] : Start..
    [sample-model-downloader] : Linux is supported
    [sample-model-downloader] : Install go and hg
    読み込んだプラグイン:fastestmirror, priorities, security
    インストール処理の設定をしています
    Loading mirror speeds from cached hostfile
    * base: www.ftp.ne.jp
    * epel: ftp.kddilabs.jp
    * extras: www.ftp.ne.jp
    * rpmforge: ftp.kddilabs.jp
    * updates: www.ftp.ne.jp
    169 packages excluded due to repository priority protections
    パッケージ golang-1.4.2-2.el6.x86_64 はインストール済みか最新バージョンです
    パッケージ mercurial-1.4-3.el6.x86_64 はインストール済みか最新バージョンです
    何もしません
    [sample-model-downloader] : go get github.com/prasmussen/gdrive/cli
    [sample-model-downloader] : go get github.com/voxelbrain/goptions
    [sample-model-downloader] : go get code.google.com/p/goauth2/oauth
    [sample-model-downloader] : git clone https://github.com/prasmussen/gdrive.git
    [sample-model-downloader] : cd /home/overlast/git/word-vector-web-api/libexec/../tmp/gdrive
    Already up-to-date.
    [sample-model-downloader] : Compile drive.go to create Google Drive CLI application
    command-line-arguments
    [sample-model-downloader] : cd /home/overlast/git/word-vector-web-api/libexec/../model/

うまくいくと、初めてdrive コマンドでモデルをダウンロードする場合には、 Google Drive からのダウンロードに必要な確認作業のための URL が表示されます。

    [sample-model-downloader] : Download sample model data file from Google Drive using drive command
    Go to the following link in your browser:
    https://accounts.google.com/o/oauth2/auth?client_id=367116221053-7n0vf5akeru7on6o2fjinrecpdoe99eg.apps.googleusercontent.com&redirect_uri=urn%3Aietf%3Awg%3Aoauth%3A2.0%3Aoob&response_type=code&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive&state=state

    Enter verification code:

この URL にブラウザでアクセスして、同意画面で同意して、確認用の token を得たら、以下のようにコピペします。

    Enter verification code: 4/m62RCGf0d81HV5sooL*********************

確認が成功すると、xz 圧縮されたサンプルモデルが model ディレクトリにダウンロードされて、さらに unxz コマンドで解凍されます。

    [sample-model-downloader] : Decompress sample model data file using unxz command
    Downloaded 'jawiki.20150602.neologd.bin.xz' at 32.7 MB/s, total 849.3 MB
    [sample-model-downloader] : Finish..

解凍されたサンプルモデルは以下の位置にあります。

    $ ls -al model/jawiki.20150602.neologd.bin.xz
    -rw-rw-r-- 1 overlast overlast 917846510  7月  2 20:57 2015 model/jawiki.20150602.neologd.bin

このモデルについて簡単なコメントを書いておきます。

- [jawiki.20150602.neologd.bin.xz (810MByte)](https://drive.google.com/file/d/0B5QYYyltotqfM2lRQ3l4Mkc5Mk0/view?usp=sharing)
    - 日本語 Wikipedia の 2015-06-02 の dump データ(jawiki-latest-pages-articles.xml.bz2)から作成
    - jawiki-latest-pages-articles.xml.bz2 から plain text を抽出する際に New Version の [WikiExtractor.py](https://svn.code.sf.net/p/apertium/svn/trunk/apertium-tools/WikiExtractor.py) を使用
        - http://wiki.apertium.org/wiki/Wikipedia_Extractor
    - 分かち書きに MeCab と mecab-ipadic-NEologd を使用
    - Word2Vec のパラメタは"-cbow 0 -size 300 -window 5 -negative 0 -hs 1 -sample 1e-5"

#### Step2. Docker image の作成
次に docker/sample_s1/Dockerfile を使って、起動すると 1.5 GByte 程度のメモリを使う Docker image を build します。

Docker の build には以下のコマンドを使います。

    $ docker/sample_s1/

もしも最後まで処理がうまくいった場合は、以下の様なメッセージが表示されます。

    $

表示されていない場合、何かの原因で build が失敗しています。

ネットワーク環境に若干左右されるみたいなので、何度か時間を変えて実行してみてください。

できあがった image は以下のディレクトリにあります。

    $

#### Step3. Docker image を使ったコンテナの起動
Step2 で作った Docker image を使ってコンテナを起動します。

起動には以下のコマンドを使います。

もしも localhost の 22670 番ポートをすでに使っている場合は、以下を編集してコマンドを実行して下さい。


おそらく以下の様な表示が出ます。

    $

コンテナの起動に成功した場合、以下のコマンドで起動したコンテナの状態を確認できます。

    $

#### Step4. API から結果を取得する
Step3 でコンテナの起動に成功している場合、curl や ブラウザで結果を確認できます。

OSX と Linux との若干のコマンドの違いを吸収する以下のコマンドを使って、結果を確認してみましょう。

まず distance で タモリ と Cosine 距離が近い単語を見てみましょう。

    (略)
    ], "status": "OK", "sort": "cosine similarity"}'

正解データがあるわけではないので、なるほど、って感じですね。

次に analogy で 「東京と東京タワー」との関係に近い「大阪」に対する東京タワー的なものが何かを見てみましょう。

    $ analogy

    '{"query": "東京 東京タワー 大阪", "method": "analogy",
    (略)
    ], "status": "OK", "sort": "cosine similarity"}'

これも正解データがあるわけではないので、なるほど、って感じですね。

実用するときは、モデルデータを改良して distance の結果を人手でフィルタリングして使うのがオススメです。

API 自体の詳しい説明は以降の「word-vector-web-api の使い方」の節に書きました。

## word-vector-web-api の使い方


### 動作に必要なもの

インストール時に以下のライブラリを順にインストールします。

- [nginx-1.8.0](http://nginx.org/) (独自のディレクトリにインストールされます)
- [nginx-msgpack-rpc-module](https://github.com/overlast/nginx-msgpack-rpc-module)
- [word2vec-msgpack-rpc-server](https://github.com/overlast/word2vec-msgpack-rpc-server)
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

はじめにサンプルモデルを用意して、それから word2vec server を 1 プロセスだけ立ち上げるサンプルを起動します。

起動した word2vec server から結果を取得した後、word-vector-web-api を停止します。

最後に word2vec server を 3 プロセス立ち上げるサンプルを起動・停止します。

具体的に何をしているかは各スクリプトを読むと分かります。

#### Step1. サンプルモデルのダウンロード
以下のモデルファイルをダウンロードして、word-vector-web-api/model 以下にコピーして下さい。


#### Step2. サンプルモデルの解凍
word-vector-web-api/model 以下にコピーしたモデルファイルを解凍します。

    $ cd word-vector-web-api
    $ unxz model/jawiki.20150602.neologd.bin.xz
    $ ls -al model
    -rw-rw-r--  1 overlast overlast  917846510  6月 28 11:27 2015 jawiki.20150602.neologd.bin

#### Step3. サンプルモデルを使って Word Vector Web API を起動
以下のコマンドでサンプルモデルを使った Word Vector Web API を起動できます。

    $ libexec/boot-word-vector-web-api-sample.sh

起動すると 1 GByte 程度のメモリを使います。

このコマンドで立ち上がるプロセスは以下のポートを使います。

| process name | port number | access to |
| --- | --- | --- |
| nginx(master) | 22670 | nginx(slave) |
| nginx(slave) | 22671 | word2vec-message-pack-server |
| word2vec-message-pack-server | 22676 | sample model |

#### Step4. サンプルモデルを使って Word Vector Web API を起動
例えば、distance 相当の結果を得る場合は、以下の様にアクセスします。

    $ wget "http://localhost:22670/distance?a1=タモリ" -o distance_tamori

例えば、analogy 相当の結果を得る場合は、以下の様にアクセスします。

    $ wget "http://localhost:22670/analogy?a1=神奈川&a2=横浜&a3=東京" -o analogy_kanagawa_yokohama_tokyo

#### Step5. サンプルモデルを使った Word Vector Web API を停止
以下のコマンドで Step3 で起動した Word Vector Web API を起動できます。

    $ libexec/quit-word-vector-web-api-sample.sh

#### Step6. サンプルモデルを使って複数プロセスを使った Word Vector Web API を起動
slave の nginx プロセスを複数立ち上げたいときは nginx.conf を編集します。

でも、大変だと思うのでとりあえずサンプルを用意してあります。

    $ libexec/boot-word-vector-web-api-3-slaves-sample.sh

起動すると計 3 GByte 程度のメモリを使います。

このコマンドで立ち上がるプロセスは以下のポートを使います。

| process name | port number | access to |
| --- | --- | --- |
| nginx(master) | 22670 | nginx(slave 1、2と3 に均等に) |
| nginx(slave 1) | 22671 | word2vec-message-pack-server 1 |
| nginx(slave 2) | 22672 | word2vec-message-pack-server 2 |
| nginx(slave 3) | 22673 | word2vec-message-pack-server 3 |
| word2vec-message-pack-server 1 | 22676 | sample model |
| word2vec-message-pack-server 2 | 22677 | sample model |
| word2vec-message-pack-server 3 | 22678 | sample model |

#### Step7. サンプルモデルを使った複数プロセスを使った Word Vector Web API を停止
以下のコマンドで Step6 で起動した Word Vector Web API を起動できます。

    $ libexec/quit-word-vector-web-api-3-slaves-sample.sh

## サンプルの実行例 (CentOS 上でインストールした場合)
### mecab-ipadic-neologd をシステム辞書として使った場合

#### どこに効果が出ている?
    正直、Wikipedia のモデルは動作はするけど具体的な良さがあまり感じられないですね。

    真面目に文書を集めてモデルを作るのがとても大切だなと心から感じます。

### 標準のシステム辞書(ipadic-2.7.0)を使った場合
    gaoh (今書いてる)

## word-vector-web-api を通じて主張したいこと
研究的な実装を C/C++ で実装して [word2vec-msgpack-rpc-server](https://github.com/overlast/word2vec-msgpack-rpc-server) と同様に msgpack-rpc-server 化すれば、LL 言語で下手な実装をするより省メモリで高速な実装を各言語の MessagePack-RPC モジュール経由で利用できる。

MessagePack-RPC は依存ライブラリが少なく、他のプロトコルに無い柔軟性があるので、研究的なものづくりに向いている。

また、選択したプログラミング言語によるメモリの無駄が少ないことは、発明された新しい技術が実応用されるうえでとても重要である。

さらに、その実装を Web API 化する場合、[nginx-msgpack-rpc-module](https://github.com/overlast/nginx-msgpack-rpc-module) を利用すれば nginx の設定ファイルを書き換えるだけで msgpack-rpc-client と HTTP Server の用意が終わる。

研究的な実装を一般のエンジニアに試してもらうには、Web API にリクエストして結果の JSON を見せるのが、個人的な経験上だは一番早いのでオススメである。

何か有益なものを実装するときは、Python ではなく C/C++ で実装し、更に Web API 化することで、最終的により広い範囲の研究者やエンジニアがユーザになるだろう。

word-vector-web-api を実用する際には、単語ベクトル作る際の日本語文の単語分割の結果は形態素解析辞書によって変わるので、mecab-ipadic と [mecab-ipadic-NEologd](http://github.com/neologd/mecab-ipadic-neologd)を併用するのが望ましい。

以上です。

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
