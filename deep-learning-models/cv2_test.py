#!/usr/bin/python
# -*- coding:utf-8 -*-

print("Importing cv2...")
import cv2
print("Importing keras...")
from inception_v3 import InceptionV3, predict
print("Imported.")
import json
import sys


def load_japanese_labels(filename):
    with open(filename, 'r') as f:
        objs = json.load(f)
    return objs


def en2ja_label(objs, en_label):
    for obj in objs:
        if obj['en'] == en_label:
            print(obj['en'] + " is [" + obj['ja'] + "]")
            return obj['ja']
    return "わかりません"


if __name__ == '__main__':
    ja_labels = load_japanese_labels('imagenet_class_index_ja.json')
    cam = cv2.VideoCapture(0)
    print("Creating model...")
    model = InceptionV3(include_top=True, weights='imagenet')
    print("Created.")
    while True:
        ret, frame = cam.read()
        k = cv2.waitKey(1)
        cv2.imshow("Frame", frame)
        
        if k == ord('q'):
            break
        img_path = "cap.png"
        cv2.imwrite(img_path, frame)
        en_label = predict(img_path)
        ja_label = en2ja_label(ja_labels, en_label)

    cam.release()
    cv2.destroyAllWindows()
    print("Bye.")
