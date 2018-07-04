# Raspberry Pi 3 Echo 

Julius, Open JTalk, OpenCV, TensorFlow/Keras を用いたスマートスピーカ on Raspberry Pi 3(B+)

## 目次
- [概要](#概要)
- [動作環境](#動作環境)
- [必要機材](#必要機材)
- [環境構築](#環境構築)
  - [OSインストール](#OSインストール)
  - [初期設定](#初期設定)
  - [不要ファイルの削除](#不要ファイルの削除)
  - [OS更新](#OS更新)
  - [Kernel更新](#Kernel更新)
  - [音声合成ソフト](#音声合成ソフト)
  - [音響モデル](#音響モデル)
  - [パッケージ管理](#パッケージ管理)
  - [音声認識ソフト](#音声認識ソフト)
  - [画像処理ソフト](#画像処理ソフト)
  - [機械学習ソフト](#機械学習ソフト)
  - [機械学習フレームワーク](#機械学習フレームワーク)
- [動作確認](#動作確認)
- [参考資料](#参考資料)
- [寄贈のお願い](#寄贈のお願い)


## 概要

- ラズパイ 3 を用いてスマートスピーカのようなものを作成します。
- 「これはなんですか？」と聞くと「これはリンゴです」と答えてくれる機能を持ちます。
- 「今日のニュースは？」と聞くとニュースをピックアップします。
- 「今日は何曜日？」と聞くと日付を教えてくれます。
- 「何時？」と聞くと時間を教えてくれます。
- 「再起動」「リブート」と命令すると再起動します。
- 「シャットダウン」「さようなら」と命令・発話するとシャットダウンします。
- 「あつくない？」と聞くと現在の CPU 温度を答えます。
- voice-cmd.txt にある通り、決められた言葉に対する効果音を鳴らし、場を盛り上げます。

## 動作環境

| 項目                  | 内容           |
|:----------------------|:---------------|
| Raspberry Pi のモデル | 3 or may 3B+   |
| CPU                   | Cortex-A53     |
| メインメモリ          | DDR2 1 GB      |
| 冷却                  | 強制冷却を推奨 |

## 必要機材

| 機材   | 説明                                | 区分       |
|:-------|:------------------------------------|:-----------|
|RasPi   | 本体                                | 必須       |
|SDカード| 高速な 16 GB 以上の microSDHCカード | 必須       |
|電源    | 3A 以上の供給能力がある電源を推奨   | 必須       |
|マイク  | USB 接続の ALSA で認識可能なマイク  | 必須       |
|スピーカ| HTMI or 3.5mm or USB 出力対応品     | 必須       |
|カメラ  | USB 接続 or RasPi Camera            | 必須       |
|GPS     | UART/USB 接続の GPS                 | オプション |

## 環境構築

- Raspberry Pi 3 上でスマートスピーカを実現するために、Julius, Open JTalk, OpenCV, TensorFlow/Keras を用います。
- 基本的にオフライン環境か細い回線を前提としているため、Google Assistant SDK 等は使いません。
- ニュースを読み上げる機能以外は、全てオフラインで実行可能であるため、ネットワークから孤立したスタンドアロン環境で動作します。
- USB モバイルバッテリーと組み合わせれば、ポータブル/ウェアラブルなスマートスピーカーになります。
- 個人情報が収集されることもありませんし、勝手に商品が購入されることもありません。

実行時に必要なソフトウェア・関連ファイルは以下です。

|ソフトウェア        | 使用用途 | バージョン            | ライセンス   |
|:-------------------|:---------|:----------------------|:-------------|
| Raspbian           | OS       | 2018-04-19            | GPL          |
| Kernel             | Kernel   | 4.14.44-v7+ #1117 SMP | GPL          |
| Julius             | 音声認識 | 4.4.2                 | 商用可       |
| Open JTalk         | 音声合成 | 1.07-2                | Modified BSD |
| OpenCV             | 画像処理 | 3.4.1                 | BSD          |
| TensorFlow         | 物体認知 | 1.8.0                 | Apache 2.0   |
| Keras              | 物体認知 | 2.2.0                 | MIT          |
| 効果音素材         | 効果音   | -                     | 商用可       |
| tf-pose-estimation | 骨格推定 | 0.1.0 (branch master) | Apache 2.0   |


ビルドする場合に必要なソフトウェアは以下です。

|ソフトウェア     | 使用用途                | バージョン  | ライセンス |
|:----------------|:------------------------|:------------|:-----------|
|gcc              | バイナリビルド          | 4.8         | GPL 3+     |
|Bazel            | TensorFlow のビルド用   | 0.10.0      | Apache 2.0 |
|Python 2         | -                       | 2.7         | PSFL       |
|Python 3         | -                       | 3.5         | PSFL       |

### OSインストール

- [日本のミラーサイト](http://ftp.jaist.ac.jp/pub/raspberrypi/raspbian/images/?C=M;O=A) から Raspbian をダウンロードし、インストールします。
- Raspbian の基本的なインストール方法は、例えば [Raspbianのインストールと最強の初期設定](https://jyn.jp/raspbian-setup/) を参照して下さい。
- Raspbian をインストールすると GUI が起動します。GUI 上で、必要に応じて Ethernet/Wi-Fi の設定を行っておきます。

### 不要ファイルの削除

自前でビルドを行う場合、16GBのSDカードの容量が圧迫される可能性があるため、不要なファイルを削除します。Raspbian Liteの場合は最初から入っていないかもしれません。
```
./setup/000_remove_offices.sh
```

Scratch, SonicPi, LibreOffice, MineCraft, Wolfram Engine が削除されます。

### 初期設定

raspi-config で初期設定を行います。
```
sudo raspi-config
```

1. Change User Password: 必要に応じてパスワードを変更します。
2. Network Options:
   1. Hostname: 必要に応じてホスト名を変更します。
   2. Wi-Fi: 必要に応じて SSID/passphrase を設定します。
3. Boot Options:
   1. Desktop / CLI: 「B2 Console Autologin」でCLI自動ログインにします。
   2. Wait for Network at Boot:「No/いいえ」を選択します。
4. Localisation Options:
   1. Change Locale: 「ja_JP.UTF-8」を選択します。
   2. Change Timezone: 「Asia/Tokyo」を選択します。
   3. Change Keyboard Layout: 「標準105キー(国際)PC」等を選択します。
   4. Change Wi-fi Country: 「JP」を選択します。
5. Interfacing Options:
   1. P1 Camera: 必要に応じて有効にします。
   2. P2 SSH: 有効にします。
   3. P6 Serial: GPS を Serial 接続する場合、有効にします。
7. Advanced Options:
   1. A1 Expand Filesystem: 領域を拡張します。
   2. A3 Memory Split: CLI なので 16 MB あれば十分だと思います。
   3. A4 Audio: 「1 Force 3.5mm」を選択します。HDMI や USB からサウンド出力する場合は、適宜調整します。

### OS更新

apt-get でソフトウェア・アップデートを実行します。
```
./setup/002_update_raspbian.sh 
```

### Kernel更新

必要に応じて Kernel/Firmware を更新します。
```
./setup/004_update_kernel.sh
```

### 音声合成ソフト

音声合成ソフトウェアである Open JTalk をインストールします。
```
./setup/010_install_open-jtalk.sh
```

### 音響モデル

HTS voice tohoku-f01 をインストールします。
```
./setup/015_get_tohoku-hts.sh
```

他にも音響モデルが色々とあります。MMDAgent の音響モデルも良く利用されています。

### パッケージ管理

- 自作バイナリの Debian パッケージ化を行うツール checkinstall をインストールします。
- これをインストールしておくと make install でインストールするソフトウェアを dpkg で削除できるようになります。
- 現在 apt-get install でインストールする checkinstall には不具合があるため、最新版を github から clone します。
- Julius, OpenCV, TensorFlow, Bazel はバイナリリリースがあるため、checkinstall は自分でビルドしてみたい人向けのものです。

```
./setup/019_checkinstall.sh
```

### 音声認識ソフト

- 音声認識ソフト Julius をインストールします。
- ビルド済みバイナリパッケージもリリースしています。
  - https://github.com/thortex/rpi3-echo/releases
- 以下のスクリプトを実行すると、julius_?.?.?-1_armhf.deb をダウンロードし、依存ライブラリと共にインストールします。
```
cd release
./install_requires_related2julius.sh
./install_julius.sh
```

- 動作に必要な grammer-kit をダウンロードします。
- 動作に必要な dictation-kit もダウンロードします。
```
./setup/030_build_opencv.sh
```

どうしても自分でビルドしたい人は、以下の手順を実行します。

- ALSA 等の音声関連開発パッケージをインストールします。
- Cortex-A53 向けに最適化ビルドします。
- スクリプト内でインストールまで行います。
```
./setup/020_prepare_julius.sh
./setup/021_build_julius.sh
```

### 画像処理ソフト

- 画像処理ソフト OpenCV をインストールします。
- ビルド済みバイナリパッケージもリリースしています。
  - https://github.com/thortex/rpi3-echo/releases
- 以下のスクリプトを実行すると、opencv_?.?.?-YYYYMMDD-1_armhf.deb をダウンロードし、依存ライブラリと共にインストールします。
```
cd release
./install_requires_related2opencv.sh
install_opencv.sh
```

どうしても自分でビルドしたい人は、以下の手順を実行します。

- 関連開発パッケージをインストールします。
- Cortex-A53 向けに最適化ビルドします。
- インストールまで行います。
```
./setup/030_build_opencv.sh
./setup/031_install_opencv.sh
```

### 機械学習ソフト

- 「これはなんですか？」とラズパイに聞いて、「これは恐らくリンゴだと思います」と答えさせるために、機械学習ライブラリ TensoFlow をインストールします。
- ビルドには数時間かかるため、TensorFlow on ARM からリリースされている、ビルド済みの Wheel パッケージを導入するのがオススメです。
- 以下で TensorFlow on ARM 版をインストールできます。
```
./setup/034_install_deps.sh
./release/install_requires_related2tensorflow.sh
./setup/035_install_tensorflow.sh
```

- TensorFlow on ARM 版ではなく、当方がビルドしたバイナリもあります。
  - https://github.com/thortex/rpi3-echo/releases
- 以下のスクリプトを実行することで、リリースページから tensorflow-?.?.?-cp35-cp35m-linux-armv7l.whl をダウンロードし、依存ライブラリと共にインストールします。
```
./setup/034_install_deps.sh
cd release
./install_requires_related2tensorflow.sh
./install_tensorflow.sh
```

どうしても自分でビルドしたい人は、まずラズパイのスワップ領域拡張を行います。
- 参考: https://github.com/samjabrahams/tensorflow-on-raspberry-pi/blob/master/GUIDE.md#2-install-a-memory-drive-as-swap-for-compiling
- 参考: https://a244.hateblo.jp/entry/2016/12/12/010429
- 参考: http://red.halfmoon.jp/raspberry-pi/post-3748/
- 参考: https://www.fabshop.jp/%E3%80%90step-27%E3%80%91swap%E9%A0%98%E5%9F%9F%E3%82%92%E5%88%A5%E3%83%87%E3%83%90%E3%82%A4%E3%82%B9%E3%81%AB%E7%A7%BB%E5%8B%95%E3%81%97%E3%81%A6ssd%E6%9C%80%E9%81%A9%E5%8C%96/

TensorFlow 1.8.0 以降のビルドには少なくともラズパイの 1 GB メインメモリと 1.5 GB 以上のスワップ領域が必要になります。

- gcc-4.8 でビルドツール Bazel をビルドします。
- gcc-4.8 で TensorFlow をビルドします。
- 当方は Raspberry Pi 3 上で 16 時間かかりました。
- Python 3 用と Python 2 用の両方の wheel パッケージをビルドする場合、32 時間程度かかりました。
```
./setup/039_gcc-4.8.sh
./setup/040_build_bazel.sh
./setup/045_build_tf_py3.sh
./setup/046_build_tf_py2.sh
```

### 機械学習フレームワーク

- TensorFlow を直接使っても良いです
- ここでは学習済みのモデルを簡単に使用するため、Keras をインストールします。
```
./setup/050_install_keras.sh
```

### 効果音素材のダウンロード

フリーの効果音素材をダウンロードします。
```
cd mp3/anime
./down.sh && ./down2.sh
cd ../..
```


## 動作確認

run.sh を実行すると Julius と rpi_echo.py スクリプトが動作します。
```
./run.sh
```

- InceptionV3 などの学習済みモデルも使用できますが、ここでは軽量な MobileNetV2 を使っています。
- 初回実行時は学習済みモデルファイルをウェブからダウンロードするため、時間がかかります。
- モデルファイルのロードにも時間がかかります。
- TensorFlow/Keras の import にも時間がかかります。
- モデルファイルはダウンロードされると ~/.keras/models に配置されます。
- 学習済みモデルの使用は https://github.com/JonathanCMitchell/mobilenet_v2_keras/releases から直接 mobilenet_v2_weights_tf_dim_ordering_tf_kernels_1.0_224.h5 をダウンロードし、~/.keras/models に配置することでも可能です。

### 録音デバイスの指定

- 複数のマイクが接続されている場合、録音デバイスを Julius に指定した方が良いです。
- デフォルト設定では C-Media Audio 互換 USB デバイスを録音デバイスに指定しています。
- もし、異なる場合は run_julius.sh の D="C-Media" を適切なデバイスのデバイス名に変更します。
- ALSA で認識している録音デバイスの一覧は以下のコマンドで確認できます。
```
./scripts/show_mic_card_id.sh 
```

### 再生デバイスの指定

- 再生デバイスのデフォルト出力先は 3.5mm pin-jack analog audio にしています。
- 変更する場合は scripts/jtalk.sh の grep bcm2835 という箇所を別のカード名称に変更します。
- ALSA で認識している再生デバイスの一覧は以下のコマンドで確認できます。
```
(LANG=C alay -l)
```

### Juliusの設定

処理速度を向上させるために、Julius は以下のデフォルト設定にしています。
```
-n 2
-output 1
-rejectshort 200
-48
-realtime
```

- -n や -output 文仮説数の探索数を設定します。
- -n は 1 に設定しても動作します。
- rejectshort により 200 msec 以下の発話は棄却されます。
- 録音デバイスの種類によっては -48 オプションは不要です。
- realtime オプションを付けると音声入力と同時に音声認識処理が並列処理されます。


## 参考資料

### 音声合成関連
- http://mahoro-ba.net/index.php?j=1875
- http://www.taneyats.com/entry/raspi-open-jtalk
- https://github.com/icn-lab/htsvoice-tohoku-f01

### OpenCV
- https://www.pyimagesearch.com/2016/04/18/install-guide-raspberry-pi-3-raspbian-jessie-opencv-3/

### TensorFlow/Keras
- https://github.com/lhelontra/tensorflow-on-arm/
- https://github.com/samjabrahams/tensorflow-on-raspberry-pi/blob/master/GUIDE.md
- https://karaage.hatenadiary.jp/entry/2017/08/09/073000
- http://uepon.hatenadiary.com/entry/2018/02/12/113432
- https://github.com/tensorflow/tensorflow/blob/master/tensorflow/tools/ci_build/pi/build_raspberry_pi.sh

### スワップ拡張
- 参考: https://a244.hateblo.jp/entry/2016/12/12/010429
- 参考: http://red.halfmoon.jp/raspberry-pi/post-3748/
- 参考: https://www.fabshop.jp/%E3%80%90step-27%E3%80%91swap%E9%A0%98%E5%9F%9F%E3%82%92%E5%88%A5%E3%83%87%E3%83%90%E3%82%A4%E3%82%B9%E3%81%AB%E7%A7%BB%E5%8B%95%E3%81%97%E3%81%A6ssd%E6%9C%80%E9%81%A9%E5%8C%96/

## 謝辞

多くの方のリソースを参考にさせて頂きました、この場をお借りして、お礼申し上げます。

### フリーの効果音素材提供元
以下サイト様の効果音を使用いたしました。
- https://soundeffect-lab.info/
- http://taira-komori.jpn.org

### 物体認知
PonDad 様の ImageNet Class Index 日本語版を改変いたしました。
- https://qiita.com/PonDad/items/c5419c164b4f2efee368

### 音声認識
Julius とのインタフェースは @fishkiller 様の XML なし版をベースにいたしました。
- https://qiita.com/fishkiller/items/c6c5c4dcd9bb8184e484

## 寄贈のお願い

- 開発機材をご提供いただける方を随時募集中です…
- Raspberry Pi 3B+, Raspberry Pi Zero (W(H)), Webcam, マイク, ヘッドセット等々…
- http://amzn.asia/00yBsf8
