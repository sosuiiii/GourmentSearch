# GourmentSearch  
## ストアURL  
[ぐるスポ](https://apps.apple.com/jp/app/%E3%81%90%E3%82%8B%E3%82%B9%E3%83%9D/id1558259279)  

## 使用した技術  
MVVMアーキテクチャ  
RxSwift/RxCocoa  
RxDataSource  
Moya  
RealmSwift  
github-flow  

CI/CD  
Bitrise  

## アプリの操作動画(GIF)  
![Videotogif](https://user-images.githubusercontent.com/41160560/111022384-ca692480-8415-11eb-82ab-6dc65c13a768.gif)

## アプリの特徴  
マップ画面では検索結果から経路表示ができて迷わない  
詳細検索で距離やジャンル、日本酒充実、などのオプションが絞れる  
検索結果からお気に入り登録ができるので、毎回探さなくても良い。  
3ページから構成されていて使いやすい。  
現在地から検索するようにしているので遠いお店は検索できない。  
ホットペッパーAPIなのでお店の数が少し少ない。  

## 技術・ライブラリ  
【アーキテクチャ】  
MVVM : KickstarterのViewModelインターフェースを採用  
       ViewModelの宣言にはas ViewModelTypeとし、制約をつけること  
【リアクティブ】  
RxSwift / RxCocoa ： 関数型×リアクティブプログラミング  
RxDataSource ： CollectionViewやTableViewにデータをバインドする  
RealmSwift ： データベース。自作クラスのRealmManagerを使うこと  
【その他】  
Moya ： API周りを担当  
PKHUD ： progressなどの簡易的なポップを出してくれる  
IBAnimatable ： アニメーションを提供してくれる。ポップ表示に使用  
SDWebImage : 画像をキャッシュしてくれる。TableViewで重宝  
GoogleMaps, Direction : マップ表示と経路表示  
CoreLocation : 位置情報などを取得できる  
【テスト】  
Quick, Nimble, RxTest : Rxのテストコード用  
XCTest : バリデーションロジックのテスト用  

--以下カスタムクラス  
PropertyWrapper : Observable、Observerの再定義を不要にするラッパー  
参考(https://gist.github.com/sgr-ksmt/2cc92d8c7d517e08767fbe296b6da720)  
RealmManager  : RealmSwiftの扱いを簡単にしてくれるクラス  
ErrorHandler ： ステータスコードでハンドルするクラス  

## 意識した点  
・API処理はマテリアライズし、購読破棄させないこと。  
・自分が使いたいと思えるUXにしたこと。  
・特にジャンル検索と経路表示、お気に入り登録とお気に入りリストの部分。  
・ライブラリを導入する前に、容易に実装可能かどうかを検討すること。  
 無作為にライブラリを入れていくとビルドが重くなり、また  
 メンテナンスの行き届いていないライブラリが溜まっていく可能性があるため。  



## 実装時間  
35時間  
Google Maps APIでマップ表示のViewをストーリーボードで生成すると  
出回っている記事と設定方法(初期化方法？)が違い少し手間取った。  

## API  
・ホットペッパーAPI  
空文字で投げるとStatus200でエラー情報が返ってきてデコードできないので  
ハンドリングで対応すること  
party_capacityは空の時String、そうでない時Intで返ってくるので  
デコード対象に入れないこと  

・Google Maps API for IOS  
googleマップの簡易機能を提供してくれるAPI  
・Direction API  
google提供の経路を表示するための経緯を提供してくれるAPI  

## 今後の予定  
・DI
・Driver, Signalの使用



