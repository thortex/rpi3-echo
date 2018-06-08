#!/usr/bin/python
# -*- coding: utf-8 -*-

import socket
import string
import subprocess
import time

host = 'localhost'
port = 10500

def omxplay(filename):
    d = 'mp3/anime/'
    status = subprocess.call("mpg321 -q " + d + filename, shell=True)

def call_jtalk(m):
    status = subprocess.call("./03_test_sound.sh" + " " + m, shell=True)
    

def jtalk(msg):
    if msg.find("不正解") > -1 or msg.find("間違い") > -1 or msg.find("ブッブー") > -1:
        status = omxplay("incorrect1.mp3")
    elif msg.find("正解") > -1 or msg.find("ピンポン") > -1:
        status = omxplay("correct1.mp3")
    elif msg.find("印刷") > -1 or msg.find("プリント") > -1:
        call_jtalk("印刷します。")
        status = omxplay("printer-print1.mp3")
    elif msg.find("時間") > -1 or msg.find("何時") > -1 or msg.find("なんじ") > -1 or msg.find("汝") > -1:
        status = subprocess.call("./04_say_now.sh", shell=True)
    elif msg.find("何日") > -1 or msg.find("何曜日") > -1 or msg.find("日付") > -1 or msg.find("曜日") > -1:
        status = subprocess.call("./04_say_date.sh", shell=True)
    elif msg.find("問題") > -1:
        status = omxplay("question1.mp3")
    elif msg.find("運命") > -1:
        status = omxplay("fate2.mp3")
    elif msg.find("残念") > -1:
        status = omxplay("fate1.mp3")
    elif msg.find("チャイム") > -1:
        status = omxplay("school-chime1.mp3")
    elif msg.find("助けて") > -1 or msg.find("ヘルプ") > -1:
        status = omxplay("morsecode-sos1.mp3")
    elif msg.find("おはよう") > -1:
        status = call_jtalk("おはようございます。")
    elif msg.find("こんにちは") > -1 or msg.find("今日") > -1:
        call_jtalk("こんにちは")
    elif msg.find("再起動") > -1 or msg.find("リブート") > -1:
        call_jtalk("再起動します。")
        stauts = subprocess.call("./reboot.sh", shell=True)
    elif msg.find("シャットダウン") > -1 or msg.find("さようなら") > -1:
        call_jtalk("シャットダウします。")
        status = subprocess.call("./shutdown.sh", shell=True)
    elif msg.find("起きて") > -1 or msg.find("アラーム") > -1:
        status = omxplay("alerm1.mp3")
    elif msg.find("エンジン") > -1 or msg.find("ブンブン") > -1:
        status = omxplay("f1-engine1.mp3")
    elif msg.find("救急車") > -1 or msg.find("怪我") > -1:
        status = omxplay("ambulance-siren1.mp3")
    elif msg.find("緊急事態") > -1 or msg.find("異常事態") > -1:
        status = omxplay("base-siren1.mp3")
    elif msg.find("ミサイル") > -1 or msg.find("発射") > -1:
        status = omxplay("missile1.mp3")
    elif msg.find("はじめ") > -1 or msg.find("スタート") > -1:
        status = omxplay("gong-played1.mp3")
    elif msg.find("終わり") > -1 or msg.find("おわり") > -1:
        status = omxplay("gong-played2.mp3")
    elif msg.find("爆破") > -1 or msg.find("爆発") > -1:
        status = omxplay("bomb1.mp3")
    elif msg.find("パトカー") > -1 or msg.find("警察") > -1:
        status = omxplay("patrol-car1.mp3")
    elif msg.find("キーボード") > -1 or msg.find("パソコン") > -1:
        status = omxplay("keyboard-high-speed1.mp3")
    elif msg.find("拍手") > -1 or msg.find("素晴らしい") > -1:
        status = omxplay("clapping-hands1.mp3")
    elif msg.find("切る") > -1 or msg.find("やられた") > -1:
        status = omxplay("katana-slash5.mp3")
    elif msg.find("トランペット") > -1 or msg.find("ファンファーレ") > -1:
        status = omxplay("trumpet1.mp3")
    elif msg.find("どんどん") > -1 or msg.find("パフパフ") > -1 or msg.find("ドンドン") > -1:
        status = omxplay("dondonpafupafu1.mp3")
    elif msg.find("規制") > -1 or msg.find("禁則") > -1:
        status = omxplay("self-regulation1.mp3")
    elif msg.find("決定") > -1 or msg.find("決めた") > -1 or msg.find("決めました") > -1:
        status = omxplay("decision8.mp3")
    elif msg.find("開始") > -1:
        status = omxplay("broadcasting-start1.mp3")
    elif msg.find("終了") > -1:
        status = omxplay("broadcasting-end1.mp3")
    elif msg.find("ホイミ") > -1 or msg.find("ベホイミ") > -1 or msg.find("ベホイム") > -1 or msg.find("ベホイマ") > -1 or msg.find("ベホマ") > -1:
        status = omxplay("magic-cure1.mp3")
    elif msg.find("ベホマラー") > -1 or msg.find("ベホマズン") > -1:
        status = omxplay("magic-cure2.mp3")
    elif msg.find("ザオ") > -1 or msg.find("ザオラル") > -1 or msg.find("ザオリク") > -1:
        status = omxplay("magic-cure3.mp3")
    elif msg.find("メラ") > -1 or msg.find("メラミ") > -1 or msg.find("メラゾーマ") > -1:
        status = omxplay("magic-flame1.mp3")
    elif msg.find("ヒャド") > -1 or msg.find("ヒャダルコ") > -1 or msg.find("ヒャダイン") > -1 or msg.find("マヒャド") > -1:
        status = omxplay("magic-ice1.mp3")
    elif msg.find("ギラ") > -1 or msg.find("ペギラマ") > -1:
        status = omxplay("magic-electron4.mp3")
    else:
        status = call_jtalk(msg)

def connect_julius():
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    i = 0
    while i < 40:
        try:
            sock.connect((host, port))
            return sock
        except:
            print("Failed to connect julius server...")

        time.sleep(1)
        i += 1
    
def main():
    sock = connect_julius()
    
    call_jtalk("整いました。")
    
    data = ""
    try:
        while True:
            while(string.find(data, "\n.") == -1):
                data = data + sock.recv(1024)

            strTemp = ""
            for line in data.split('\n'):
                index = line.find('WORD="')
                if index != -1:
                    line = line[index+6:line.find('"',index+6)]
                    strTemp = strTemp + line

            if strTemp != "": 
                print("Result: [" + strTemp + "]")
                jtalk(strTemp)
            else:
                print(".")
            data = ""
    except KeyboardInterrupt:
        print("Exit")

main()
