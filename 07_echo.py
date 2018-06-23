#!/usr/bin/python
# -*- coding: utf-8 -*-

import random
import socket
import string
import subprocess
import time
import httplib

host = 'localhost'
port = 10500

known_news = []
news_topics = []

def mp3play(filename):
    d = 'mp3/anime/'
    status = subprocess.call("mpg321 -q " + d + filename, shell=True)

def call_jtalk(m):
    status = subprocess.call("./03_test_sound.sh" + " " + m, shell=True)

def pickup_news(con, uri_path):
    # topics = []
    con.request("GET", uri_path)
    resp = con.getresponse()
    data = resp.read()
    for line in data.split('\n'):
        # print(line)
        if line.find("<title>") > -1 and line.find("Yahoo") == -1:
            # print("title")
            topic = line.replace("<title>", "").replace("</title>", "")
            if not topic in news_topics:
                news_topics.append(topic)
                print("%s:%s" % (uri_path, topic))
                
def read_news(msg):
    try:
        if len(news_topics) == 0:
            con = httplib.HTTPSConnection("news.yahoo.co.jp", timeout=10)
            pickup_news(con, "/pickup/world/rss.xml")
            pickup_news(con, "/pickup/entertainment/rss.xml")
            pickup_news(con, "/pickup/computer/rss.xml")
            pickup_news(con, "/pickup/local/rss.xml")
            pickup_news(con, "/pickup/domestic/rss.xml")
            pickup_news(con, "/pickup/economy/rss.xml")
            pickup_news(con, "/pickup/sports/rss.xml")
            pickup_news(con, "/pickup/science/rss.xml")
        n = len(news_topics)
        print("length:%d" % (n))

        t = 0
        while t < 20:
            i = random.randrange(n)
            print(i)
            msg = news_topics[i]
            print(msg)            
            t += 1
            if msg in known_news:
                continue
            call_jtalk(msg.replace(" ", "、"))
            known_news.append(msg)
            break
    except Exception as e: 
        print(e.args)
        pass

    
def jtalk(msg):
    command_table = [
        {"msg":"間違い", "snd":"incorrect1.mp3"},
        {"msg":"正解", "snd":"correct1.mp3"},
        {"msg":"ピンポン", "snd":"correct1.mp3"},
        {"msg":"印刷", "snd":"printer-print1.mp3", "say":"印刷します。"},
        {"msg":"プリント", "snd":"printer-print1.mp3", "say":"印刷します。"},
        {"msg":"時間", "cmd":"./04_say_now.sh"},
        {"msg":"何時", "cmd":"./04_say_now.sh"},
        {"msg":"なんじ", "cmd":"./04_say_now.sh"},
        {"msg":"汝", "cmd":"./04_say_now.sh"},
        {"msg":"何日", "cmd":"./04_say_date.sh"},
        {"msg":"何曜日", "cmd":"./04_say_date.sh"},
        {"msg":"日付", "cmd":"./04_say_date.sh"},
        {"msg":"曜日", "cmd":"./04_say_date.sh"},
        {"msg":"問題", "snd":"question1.mp3"},
        {"msg":"運命", "snd":"fate2.mp3"},
        {"msg":"残念", "snd":"fate1.mp3"},
        {"msg":"チャイム", "snd":"school-chime1.mp3"},
        {"msg":"助けて", "snd":"morsecode-sos1.mp3"},
        {"msg":"ヘルプ", "snd":"morsecode-sos1.mp3"},
        {"msg":"おはよう", "say":"おはようございます。"},
        {"msg":"こんにちは", "say":"こんにちは"},
        {"msg":"今日", "say":"こんにちは"},
        {"msg":"再起動", "say":"再起動します。", "cmd":"./cmds/reboot.sh"},
        {"msg":"リブート", "say":"再起動します。", "cmd":"./cmds/reboot.sh"},
        {"msg":"シャットダウン", "say":"シャットダウします。", "cmd":"./cmds/shutdown.sh"},
        {"msg":"さようなら", "say":"シャットダウします。", "cmd":"./cmds/shutdown.sh"},
        {"msg":"起きて", "snd":"alerm1.mp3"},
        {"msg":"アラーム", "snd":"alerm1.mp3"},
        {"msg":"ぶんぶん", "snd":"f1-engine1.mp3"},
        {"msg":"ブンブン", "snd":"f1-engine1.mp3"},
        {"msg":"救急車", "snd":"ambulance-siren1.mp3"},
        {"msg":"怪我", "snd":"ambulance-siren1.mp3"},
        {"msg":"緊急事態", "snd":"base-siren1.mp3"},
        {"msg":"異常事態", "snd":"base-siren1.mp3"},
        {"msg":"ミサイル", "snd":"missile1.mp3"},
        {"msg":"発射", "snd":"missile1.mp3"},
        {"msg":"はじめ", "snd":"gong-played1.mp3"},
        {"msg":"スタート", "snd":"gong-played1.mp3"},
        {"msg":"終わり", "snd":"gong-played2.mp3"},
        {"msg":"爆破", "snd":"bomb1.mp3"},
        {"msg":"爆発", "snd":"bomb1.mp3"},
        {"msg":"パトカー", "snd":"patrol-car1.mp3"},
        {"msg":"パトロールカー", "snd":"patrol-car1.mp3"},
        {"msg":"警察", "snd":"patrol-car1.mp3"},
        {"msg":"ピーポ", "snd":"patrol-car1.mp3"},
        {"msg":"キーボード", "snd":"keyboard-high-speed1.mp3"},
        {"msg":"パソコン", "snd":"keyboard-high-speed1.mp3"},
        {"msg":"拍手", "snd":"clapping-hands1.mp3"},
        {"msg":"素晴らしい", "snd":"clapping-hands1.mp3"},
        {"msg":"すばらしい", "snd":"clapping-hands1.mp3"},
        {"msg":"切る", "snd":"katana-slash5.mp3"},
        {"msg":"やられた", "snd":"katana-slash5.mp3"},
        {"msg":"トランペット", "snd":"trumpet1.mp3"},
        {"msg":"ファンファーレ", "snd":"trumpet1.mp3"},
        {"msg":"どんどん", "snd":"dondonpafupafu1.mp3"},
        {"msg":"パフパフ", "snd":"dondonpafupafu1.mp3"},
        {"msg":"ドンドン", "snd":"dondonpafupafu1.mp3"},
        {"msg":"禁則", "snd":"self-regulation1.mp3"},
        {"msg":"決定", "snd":"decision8.mp3"},
        {"msg":"決めた", "snd":"decision8.mp3"},
        {"msg":"決めました", "snd":"decision8.mp3"},
        {"msg":"開始", "snd":"broadcasting-start1.mp3"},
        {"msg":"終了", "snd":"broadcasting-end1.mp3"},
        {"msg":"寒い", "snd":"gust1.mp3"},
        {"msg":"電車", "snd":"train-bell1.mp3"},
        {"msg":"機関車", "snd":"locomotive-whistle1.mp3"},
        {"msg":"船", "snd":"ship-big-whistle1.mp3"},
        {"msg":"エンジン", "snd":"car-engine1.mp3"},
        {"msg":"ライオン", "snd":"lion1.mp3"},
        {"msg":"象", "snd":"elephant1.mp3"},
        {"msg":"犬", "snd":"dog2.mp3"},
        {"msg":"猫", "snd":"cat-cry3.mp3"},
        {"msg":"消防車", "snd":"fireengine_starting.mp3"},
        {"msg":"ニュース", "func":read_news},
        {"msg":"暑い", "cmd":"./cmds/cputemp.sh"},
        {"msg":"暑くない", "cmd":"./cmds/cputemp.sh"},
        # {"msg":"", ""},
    ]

    found = False
    for row in command_table:
        if msg.find(row["msg"]) > -1:
            found = True
            # say
            if "say" in row and row["say"] != "":
                call_jtalk(row["say"])
            # play sound
            if "snd" in row and row["snd"] != "":
                status = mp3play(row["snd"])
            # execute command
            if "cmd" in row and row["cmd"] != "":
                status = subprocess.call(row["cmd"] + " " + msg, shell=True)
            if "func" in row and row["func"] != "":
                row["func"](msg)
            break

    if not found:
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
    
    call_jtalk("おはようございます。")
    
    data = ""
    try:
        while True:
            while(string.find(data, "\n.") == -1):
                data = data + sock.recv(1024)

            strTemp = ""
            for line in data.split('\n'):
                # print(line)
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
