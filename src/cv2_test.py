#!/usr/bin/env python
# -*- coding:utf-8 -*-

import json
import numpy as np
import sys

print("Importing cv2...")
import cv2
print("OpenCV Version: %s" % (cv2.__version__))

print("Importing tensorfow...")
import tensorflow as tf
#import tensorflow.logging
#import logging
#log = logging.getLogger('tensorflow')
#log.setLevel(logging.DEBUG)
#formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
#fh = logging.FileHandler('tensorflow.log')
#fh.setLevel(logging.DEBUG)
#fh.setFormatter(formatter)
#log.addHandler(fh)
#config = tf.ConfigProto()
#session = tf.Session(config=config)
print("TensorFlow Version: %s" % (tf.__version__))

print("Importing keras...")
from keras.backend.tensorflow_backend import set_session
#set_session(session)
import keras
print("Keras Version: %s" % (keras.__version__))
if False:
    from keras.applications.mobilenetv2 import MobileNetV2
else:
    from keras.applications.mobilenet import MobileNet
    from keras.preprocessing import image
    from keras.applications.mobilenet import preprocess_input
    from keras.applications.mobilenet import decode_predictions
    
def load_mobilenet_v2(shape):
    print("Loading model...")
    if False:
        model = MobileNetV2(input_shape=shape, weights='imagenet')
        print("Created MobileNet V2 model.")
    else:
        model = MobileNet(include_top=True, weights='imagenet')
        print("Created MobileNet model.")
        
    return model

def load_japanese_labels(filename):
    if sys.version_info >= (3, 0):
        with open(filename, 'r', encoding="utf-8") as f:
            objs = json.load(f)
    else:
        import codecs
        with codecs.open(filename, 'r', 'utf-8') as f:
            objs = json.load(f)
        
    return objs


def en2ja_label(objs, en_wnid, acc):
    ja_label = u""
    for obj in objs:
        if obj['num'] == en_wnid:
            print(obj['en'] + " is [" + obj['ja'] + "]")
            ja_label = obj['ja']
            break
                
    if acc > 0.7:
        prefix = u""
        postfix = u"です。"
    elif acc > 0.4:
        prefix = u"多分、" 
        postfix = u"だと思います。"
    elif acc > 0.1:
        prefix = u"もしかしたら、"
        postfix = u"かもしれません。"
    else:
        prefix = u"すみません、"
        ja_label = u""
        postfix = u"わかりません。"
        
    result = prefix + ja_label + postfix
    return result

if __name__ == '__main__':
    img_shape = (224, 224, 3)
    ja_labels = load_japanese_labels('imagenet_class_index_ja.json')
    cam = cv2.VideoCapture(0)
    model = load_mobilenet_v2(img_shape)

    width = cam.get(cv2.CAP_PROP_FRAME_WIDTH)
    height = cam.get(cv2.CAP_PROP_FRAME_HEIGHT)
    print('Image Capture Size: width=%d height=%d' % (width, height))
    # TODO 
    while True:
        ret, frame = cam.read()
        k = cv2.waitKey(1)
        #cv2.imshow("Frame", frame)
        
        if k == ord('q'):
            break
        img_path = "cap.png"
        cv2.imwrite(img_path, frame)

        img_path = 'elephant.jpg'
        img = image.load_img(img_path, target_size=(224, 224))
        x = image.img_to_array(img)
        x = np.expand_dims(x, axis=0)
        x = preprocess_input(x)
        
        preds = model.predict(x)
        
        results = decode_predictions(preds, top=1)[0]
        
        for r in results:
            #print('Predicted:', r)
            en_wnid = r[0]
            acc = r[2]
            
            ja_label = en2ja_label(ja_labels, en_wnid, acc)
            print(ja_label)
        break

    cam.release()
    cv2.destroyAllWindows()
    print("Bye.")
