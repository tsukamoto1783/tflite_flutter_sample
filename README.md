[tflite_flutter_helper/example/image_classification](https://github.com/am15h/tflite_flutter_helper/tree/master/example/image_classification) のclone。

clone後、ios,android両方でbuildが通るように調整。

----------

### clone後に対応したこと
flutter version 3.7.10 で動作確認済み。
- androidのbuild通るように設定の調整
- ソースに処理コメント追加
- iosのbuild通るように設定の調整（現状実機のみbuildできる）  
 -　ドキュメントに記載のTensorFlowLiteC.freamwork を配置。  
 -　podfileに右記追記  「pod 'TensorFlowLiteC', '~> 2.6.0'」  
 -　シミュレーターでbuildするとCpuが違うと怒られるので、実機でbuildすると成功。  
 -　実機なので、info.plistにカメラ許可設定追記
<!-- 　　  Error (Xcode): Building for iOS Simulator, but linking in object file built for iOS, file -->
<!-- '/Users/tsukamotoyuto/development/[tflite_sample]/tflite_pubdev_library/example/ios/Pods/TensorFlowLiteC/Frameworks/TensorFlowLiteC.framework/TensorFlowLiteC' for architecture arm64 -->


&nbsp;
### ローカル環境でのセットアップ
以下の手順参照。(androidはプロジェクト内で実行してるので不要かも)  
https://pub.dev/packages/tflite_flutter/versions/0.9.1#important-initial-setup--add-dynamic-libraries-to-your-app

&nbsp;
### 備考
- tflite_flutter_helperは、[tflite_flutter]() をラップした便利版ライブラリ。  
なので、helperライブラリの中のpubspec.yamlにtflite_flutter（ver:0.9.1）が導入済み。
- helperライブラリの開発は終了(DISCONTINUED)している。
- tflite_flutter単体だと、画像の変換処理とかがめんどくさい？めんどくさいだけど頑張ればできるか？
- iosだと実機しかできない？ドキュメントには実機で動かすことが推奨されている。  
  以下の記事にもあるので、なんやかんや調整したらできそう？  
  https://qiita.com/sugityan/items/44b850ce97c9293ff172
- 最新のバージョン(ver.0.3.1)だと、androidがflutter3.0系に非対応。  
  なので、他の人がカスタマイズしたライブラリを使用。  
  意外と最近でもPRがあったりしてる。  
  https://github.com/am15h/tflite_flutter_helper/issues/57


&nbsp;
### ライブラリ
**tflite_flutter**  
【最新: 0.9.5現在】  
ここ最近アップデートがされている。ただ、helperライブラリが非推奨となり、今後破壊的な変更となるかも？  
また、iosのbuild方法も現状未記載。  
https://pub.dev/packages/tflite_flutter  

> (Important) Initial setup : Add dynamic libraries to your app   
iOS  
TODO: Sample now works, info soon.  
Note: TFLite may not work in the iOS simulator. It's recommended that you test with a physical device  

> TFLite Flutter Helper Library  
The helper library has been deprecated. New development underway for a replacement at https://github.com/google/flutter-mediapipe  

【0.9.1】  
helperライブラリにラップされているバージョン。  
このバージョンのセットアップ方法を基にサンプルアプリはbuildしている。(上記参照)  
https://pub.dev/packages/tflite_flutter/versions/0.9.1

**tflite_flutter_helper**  
https://pub.dev/packages/tflite_flutter_helper

-------------------

# 調査結果の諸々メモ
### 使用できそうなMLのライブラリ
flutterでMLを実装するための調査。  
MLのパッケージについては、以下で検索してみた。  
https://fluttergems.dev/machine-learning/  

以下二つを検討。  

- **https://pub.dev/packages/google_ml_kit**  
firebaseが提供しているMLのプラグインを使用できるパッケージ。  
Firebaseがデフォルトで提供している学習モデルに関しては使用できるそう。  
カスタムモデルに関しては、firebaseに登録してアプリ内でDLはできるが、推論は結局自前で組み込んで使用する必要がある。  
[Firebase Doc](https://firebase.google.com/docs/ml/flutter/use-custom-models?hl=ja#3_perform_inference_on_input_data)
  > Dart 用に維持されている TensorFlow Lite ライブラリがない場合は、iOS および Android 用のネイティブ TensorFlow Lite ライブラリと統合する必要があります  

- **https://pub.dev/packages/tflite_flutter**  
[上記参照](https://github.com/tsukamoto1783/tflite_flutter_sample/edit/main/README.md#%E5%82%99%E8%80%83)  

### Neutral Network console
Sonyの機械学習(Neutral Network)をGUI操作できるツールの商標。  
nnablaというpythonフレームワークを使用している。拡張子は、「.nnp」  
TransFlow等のメジャーな形式に変換することができる。  

nnablaを使用して、MLをいじってみようかとおもったが、M1 Macだと思うようにインストールができない。。  
GUI上でもTensorFlow形式にして出力するできて、コマンド操作でも変換できることが記載されてるので、一旦調査終了。  

※ M1でも調整したらnnablaインストールできるらしい（Issueで聞くだけ聞いたけど未実施、、）  
https://github.com/sony/nnabla/issues/1191

※ 自前のIntel Macでnnableライブラリを使用し、以下のコマンド入力でtflite形式に変換することは確認済み  
[Neutral Network liblarys/Doc/File Format Converter]https://nnabla.readthedocs.io/en/latest/python/file_format_converter/file_format_converter.html#tensorflow-lite  

【参考サイト】  
[プログラミングなしで最新AIがどんどん無料で遊べるnnablaのサンプルがなんだかめちゃくちゃ充実しててスゴイ](https://note.com/shi3zblog/n/n933ba21a4dea  
[Neutral Network liblarys](https://nnabla.org/ja/)  
[TensorFlowのモデルファイル.pbを.tfliteに変換するときの注意点](https://rightcode.co.jp/blog/information-technology/tensorflow-model-file-conversion-important-point)  

### 学習モデルについて
学習モデルは、無料で公開されているものが沢山ある。  
メジャーな形式の一つとして、TensorFlowがある。  
TensorFlowは、Googleが開発している機械学習のためのオープンソースソフトウェアライブラリ。  

モバイルや組み込みでも推論できるように軽量化してのが、TensorFlow Lite。  
→[公式ドキュメント](https://www.tensorflow.org/?hl=ja)には、Flutterのサンプルはない。

【学習モデル】  
[TensorFlow/データセット](https://www.tensorflow.org/datasets/catalog/overview?hl=ja)  
[TensorFlow Hub](https://tfhub.dev/)  
[Keras](https://keras.io/ja/)  


### その他参考記事
[TensorFlow Liteを使ったFlutterによるモバイル画像識別器を作ってみた](https://future-architect.github.io/articles/20220321a/)  
[【Flutter】Androidで画像分類を行う方法](https://koubou-rei.com/entry/flutter-imgclass)  
[M1 Mac に挫けない！TensorFlow に躓かない開発環境をつくる](https://data.gunosy.io/entry/tensorflow_on_m1)  

### memo
機械学習の、「学習」「評価」「推論」について説明してくれますか？  

> ChatGPT  
機械学習は、データを用いて特定のタスクを実行するために、アルゴリズムが自動的に改善される技術です。機械学習プロセスには、「学習」、「評価」、「推論」の3つの主要な段階があります。  

> 学習（訓練）：  
学習フェーズでは、アルゴリズムは「訓練データ」と呼ばれる大量のデータセットを使って、特定のタスクを実行する方法を学びます。訓練データは、入力データ（特徴）とそれに対応する出力データ（ラベル）から構成されます。アルゴリズムは、この訓練データを使用して、入力と出力の関係を学ぶことで、未知のデータに対しても正確な予測ができるようになります。  

> 評価（検証）：  
評価フェーズでは、アルゴリズムの性能を測定します。このために、「検証データ」と呼ばれる新しいデータセットが使用されます。検証データは、訓練データとは異なりますが、同じような特徴とラベルを持っています。アルゴリズムが検証データでどの程度正確な予測を行えるかを評価することで、アルゴリズムの汎用性と過学習のリスクを測定できます。  

> 推論（テスト）：  
推論フェーズでは、学習と評価を経て改善されたアルゴリズムを使って、実世界のデータに対して予測や分類を行います。この段階では、「テストデータ」と呼ばれる新しい未知のデータセットが使用されます。テストデータは、入力データのみが含まれており、アルゴリズムはこれらのデータに基づいて出力を生成します。推論段階での予測結果は、実際のアプリケーションや問題解決に使用されます。  

評価は、あくまでも学習結果の制度を測るものであって、1→3と実施しても問題はない？

> ChatGPT  
評価（検証）の目的は、学習されたモデルの汎化性能を測定することです。つまり、未知のデータに対してモデルがどの程度正確に予測できるかを評価することです。理論的には、学習（訓練）フェーズの後に推論（テスト）フェーズに直接移行することもできます。しかし、その場合、モデルが過学習しているかどうか、また汎化性能がどの程度あるかを確認できません。  

> 評価（検証）フェーズを経ることで、モデルの性能を測定し、過学習や未学習を検出することができます。過学習が検出された場合、モデルを改良して再度学習させることが一般的です。評価フェーズをスキップして学習と推論の間に挟まない場合、モデルの性能に不確実性が残ります。これは、特に実世界のアプリケーションで重要な問題を解決する場合に問題となります。  

> したがって、評価フェーズは、機械学習プロセスにおいて重要な役割を果たしています。モデルの性能を測定し、過学習や未学習のリスクを軽減することで、最終的な推論フェーズでより正確な予測が可能になります。  
