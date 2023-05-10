import 'dart:math';

import 'package:image/image.dart';
import 'package:collection/collection.dart';
import 'package:logger/logger.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

abstract class Classifier {
  late Interpreter interpreter;
  late InterpreterOptions _interpreterOptions;

  var logger = Logger();

  late List<int> _inputShape;
  late List<int> _outputShape;

  late TensorImage _inputImage;
  late TensorBuffer _outputBuffer;

  late TfLiteType _inputType;
  late TfLiteType _outputType;

  final String _labelsFileName = 'assets/labels.txt';

  final int _labelsLength = 1001;

  late var _probabilityProcessor;

  late List<String> labels;

  String get modelName;

  NormalizeOp get preProcessNormalizeOp;
  NormalizeOp get postProcessNormalizeOp;

  Classifier({int? numThreads}) {
    _interpreterOptions = InterpreterOptions();

    if (numThreads != null) {
      _interpreterOptions.threads = numThreads;
    }

    loadModel();
    loadLabels();
  }

  // モデルデータの読み込み
  Future<void> loadModel() async {
    try {
      interpreter =
          await Interpreter.fromAsset(modelName, options: _interpreterOptions);
      print('Interpreter Created Successfully');

      _inputShape = interpreter.getInputTensor(0).shape;
      _outputShape = interpreter.getOutputTensor(0).shape;
      _inputType = interpreter.getInputTensor(0).type;
      _outputType = interpreter.getOutputTensor(0).type;

      print('Input Tensor Shape: $_inputShape');
      print('Output Tensor Shape: $_outputShape');
      print('Input Tensor Type: $_inputType');
      print('Output Tensor Type: $_outputType');

      // 出力バッファの作成
      _outputBuffer = TensorBuffer.createFixedSize(_outputShape, _outputType);

      // 後処理の正規化操作を追加
      _probabilityProcessor =
          TensorProcessorBuilder().add(postProcessNormalizeOp).build();
    } catch (e) {
      print('Unable to create interpreter, Caught Exception: ${e.toString()}');
    }
  }

  // ラベルの読み込み
  Future<void> loadLabels() async {
    labels = await FileUtil.loadLabels(_labelsFileName);
    if (labels.length == _labelsLength) {
      print('Labels loaded successfully');
    } else {
      print('Unable to load labels');
    }
  }

  // 画像の前処理
  TensorImage _preProcess() {
    int cropSize = min(_inputImage.height, _inputImage.width);

    // 画像をリサイズして正規化
    return ImageProcessorBuilder()
        .add(ResizeWithCropOrPadOp(cropSize, cropSize))
        .add(ResizeOp(
            _inputShape[1], _inputShape[2], ResizeMethod.NEAREST_NEIGHBOUR))
        .add(preProcessNormalizeOp)
        .build()
        .process(_inputImage);
  }

// 推論
  Category predict(Image image) {
    // ------ 画像の前処理 ------
    final pres = DateTime.now().millisecondsSinceEpoch;
    // 1.モデルが求める入力画像の型をTensorImageにセット
    _inputImage = TensorImage(_inputType);
    // 2.Image(入力画像)をTensorImageにロード
    _inputImage.loadImage(image);
    // 3.画像の前処理を実行
    _inputImage = _preProcess();
    final pre = DateTime.now().millisecondsSinceEpoch - pres;

    print('画像の前処理完了');
    print('Time to load image: $pre ms');

    final runs = DateTime.now().millisecondsSinceEpoch;
    // 推論を実行し、結果を_outputBufferに格納
    interpreter.run(_inputImage.buffer, _outputBuffer.getBuffer());
    final run = DateTime.now().millisecondsSinceEpoch - runs;

    print('推論実行完了');
    print('Time to run inference: $run ms');

    // 出力結果のdataを取得
    // print(_outputBuffer.getDoubleList());

    // ラベル付けされた確率値を含むマップを生成する
    Map<String, double> labeledProb = TensorLabel.fromList(
            labels, _probabilityProcessor.process(_outputBuffer))
        .getMapWithFloatValue();

    // ラベル付けされた確率値のマップから最も確率の高い予測ラベルを取得し、返却
    final pred = getTopProbability(labeledProb);
    return Category(pred.key, pred.value);
  }

  void close() {
    interpreter.close();
  }
}

// 最も確率の高い予測ラベルを取得する関数
MapEntry<String, double> getTopProbability(Map<String, double> labeledProb) {
  // 値が大きい順にエントリを並べ替えるプライオリティキューを生成する
  var pq = PriorityQueue<MapEntry<String, double>>(compare);
  pq.addAll(labeledProb.entries);

  // 最も値が大きいエントリを取得して返す
  return pq.first;
}

// プライオリティキューがエントリを並べ替えるための比較関数
int compare(MapEntry<String, double> e1, MapEntry<String, double> e2) {
  if (e1.value > e2.value) {
    return -1;
  } else if (e1.value == e2.value) {
    return 0;
  } else {
    return 1;
  }
}
