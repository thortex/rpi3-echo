## TensorFlow 1.5 以上の場合、ConcatCPU のリンクエラーでビルドに失敗する

参考リンクとしては以下。

- https://github.com/tensorflow/tensorflow/issues/17790
- https://github.com/tensorflow/serving/issues/852
- https://stackoverflow.com/questions/48553812/tensorflow-1-5-on-raspberry-pi3

Raspberry Pi における TensorFlow のビルド方法は以下を参考にしている。
- https://github.com/samjabrahams/tensorflow-on-raspberry-pi/blob/master/GUIDE.md
- https://github.com/lhelontra/tensorflow-on-arm

現状、tensorflow/core/kernels/list_kernels.h で定義される
TensorShapeFromTensor クラスから ConcatCPU が使用されているので、
work-around として、ConcatCPU をコメントアウトしている。

