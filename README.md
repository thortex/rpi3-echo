# Raspberry Pi 3 Echo 

Julius, Open JTalk, OpenCV, TensorFlow/Keras を用いた AI スピーカ on Raspberry Pi 3

## 目次
- [動作環境](#動作環境)
- [必要機材](#必要機材)
- [環境構築](#環境構築)
  - [OSインストール](#OSインストール)
  - [初期設定](#初期設定)
  - [不要ファイルの削除](#不要ファイルの削除)
  - [OS更新](OS更新)
  - [Kernel更新](Kernel更新)
  
- [参考資料](#参考資料)

## 動作環境

| 項目                  | 内容           |
|:----------------------|:---------------|
| Raspberry Pi のモデル | 3B+ or 3       |
| CPU                   | Cortex-A53     |
| メインメモリ          | DDR2 1 GB      |
| 冷却                  | 強制冷却を推奨 |

## 必要機材

| 機材   | 説明                                | 区分       |
|:-------|:------------------------------------|:-----------|
|RasPi   | 本体                                | 必須       |
|SDカード| 高速な 16 GB 以上の microSDHCカード | 必須       |
|電源    | 3A以上の供給能力がある電源を推奨    | 必須       |
|マイク  | USB 接続の ALSA で認識可能なマイク  | 必須       |
|スピーカ| 3.5mmピンジャック アナログ出力対応品| 必須       |
|カメラ  | USB 接続 or RasPi Camera            | 必須       |
|GPS     | UART/USB 接続の GPS                 | オプション |

## 環境構築

-Raspberry Pi 3 上で AI スピーカを実現するために、Julius, Open JTalk, OpenCV, TensorFlow/Keras を用います。
-基本的にオフライン環境か細い回線を前提としているため、Google Assistant SDK 等は使いません。

実行時に必要なソフトウェアは以下です。

|ソフトウェア     | 使用用途 | バージョン            |
|:----------------|:---------|:----------------------|
|Raspbian         | OS       | 2018-04-19            |
|Linux Kernel     | Kernel   | 4.14.44-v7+ #1117 SMP |
|Julius           | 音声認識 | 4.4.2                 |
|Open JTalk       | 音声合成 | 1.07-2                |
|OpenCV           | 画像処理 | 3.4.1                 |
|TensorFlow       | 物体認知 | 1.9.0-rc1             |
|Keras            | 物体認知 | 2.1.5                 |

ビルド時に必要なソフトウェアは以下です。

|ソフトウェア     | 使用用途                | バージョン  |
|:----------------|:------------------------|:------------|
|gcc              | バイナリビルド          | < 7.1       |
|Bazel            | TensorFlow のビルド用   | <= 0.10.0   |
|Python 2         | -                       | >= 2.7.13   |
|Python 3         | -                       | >= 3.5.3    |

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
   3. A4 Audio: 「1 Force 3.5mm」を選択します。

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

## 参考資料



