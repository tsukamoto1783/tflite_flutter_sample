[tflite_flutter_helper/example/image_classification](https://github.com/am15h/tflite_flutter_helper/tree/master/example/image_classification) のclone。

clone後、ios,android両方でbuildが通るように調整。

----------

## clone後に対応したこと
- androidのbuild通るように設定の調整
- ソースに処理コメント追加
- iosのbuild通るように設定の調整（現状実機のみbuildできる）

&nbsp;
## fvm 
flutter version 3.7.10 で動作確認済み。

&nbsp;
## ローカル環境でのセットアップ
以下の手順参照。(androidはプロジェクト内で実行してるので不要かも)  
https://pub.dev/packages/tflite_flutter/versions/0.9.1#important-initial-setup--add-dynamic-libraries-to-your-app

&nbsp;
## 備考
- tflite_flutter_helperは、[tflite_flutter]() をラップした便利版ライブラリ。  
なので、helperライブラリの中のpubspec.yamlにtflite_flutter（ver:0.9.1）が導入済み。
- helperライブラリの開発は終了(DISCONTINUED)している。
- tflite_flutter単体だと、画像の変換処理とかがめんどくさい？めんどくさいだけど頑張ればできるか？
- iosだと実機しかできない？ドキュメントには実機で動かすことが推奨されている。  
  以下の記事にもあるので、なんやかんや調整したらできそう？  
  https://qiita.com/sugityan/items/44b850ce97c9293ff172
- 最新のバージョン(ver.0.3.1)だと、flutter3.0系に非対応。  
  なので、他の人がカスタマイズしたライブラリを使用。  
  意外と最近でもPRがあったりしてる。  
  https://github.com/am15h/tflite_flutter_helper/issues/57



&nbsp;
## ライブラリ
### tflite_flutter
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

### tflite_flutter_helper
https://pub.dev/packages/tflite_flutter_helper


