# GourmentSearch  
![Videotogif](https://user-images.githubusercontent.com/41160560/111022384-ca692480-8415-11eb-82ab-6dc65c13a768.gif)

## アプリの特徴  
マップ画面では検索結果から経路表示ができて迷わない  
詳細検索で距離やジャンル、日本酒充実、などのオプションが絞れる  
検索結果からお気に入り登録ができるので、毎回探さなくても良い。  
3ページから構成されていて使いやすい。  
現在地から検索するようにしているので遠いお店は検索できない。  
ホットペッパーAPIなのでお店の数が少し少ない。  

## 意識した点  
自分が使いたいと思えるUXにしたこと。  
特にジャンル検索と経路表示、お気に入り登録とお気に入りリストの部分。  

## 技術面  
MVVMを採用し、どこかがFatにならないようにした。  
ViewModelがFatになりがちなので、バリデーションロジックや   
DBなどのデータへのアクセスをなるべくモデル層に切り出した。  
KickstarterのViewModelインターフェースパターンでで特に見られる  
冗長なObserverやObservableのローカル変数の再定義を解決するために、  
propertyWrapperを使ってそれを不要にした。  
-> 外からアクセスする際はobservableが参照され、  
   中で使う分にはrelayにアクセス出来るので再定義が不要になる。  

## 実装日数  
7日ほど  
土日を使った作業が2日
業務後の2時間作業が３日  
細かい修正やテストコードで2~3日

## API  
・ホットペッパーAPI  
空文字で投げるとStatus200でエラー情報が返ってきてデコードできないので  
空文字で検索クエリは投げないこと  
party_capacityは空の時String、そうでない時Intで返ってくるので  
デコード対象に入れないこと  

・Google Maps for IOS  
googleマップの簡易機能を提供してくれるAPI  
・Direction API  
google提供の経路を表示するための経緯を提供してくれるAPI  

## 技術・ライブラリ  
MVVM : KickstarterのViewModelインターフェースを採用  
       ViewModelの宣言にはas ViewModelTypeとし、制約をつけること  
RxSwift / RxCocoa ： 関数型×リアクティブプログラミング  
RxDataSource ： CollectionViewやTableViewにデータをバインドする  
Moya ： API周りを担当  
RealmSwift ： データベース。自作クラスのRealmManagerを使うこと  
PKHUD ： progressなどの簡易的なポップを出してくれる  
IBAnimatable ： アニメーションを提供してくれる。ポップ表示に使用  
SDWebImage : 画像をキャッシュしてくれる。TableViewで重宝  
GoogleMaps, Direction : マップ表示と経路表示  
Quick, Nimble, RxTest : テストコード用  
CoreLocation : 位置情報などを取得できる  
--以下カスタムクラス  
PropertyWrapper : Observable、Observerの再定義を不要にするラッパー  
(https://gist.github.com/sgr-ksmt/2cc92d8c7d517e08767fbe296b6da720)  
RealmManager  : RealmSwiftの扱いを簡単にしてくれるクラス  
ErrorHandler ： ステータスコードでハンドルするクラス    

## CI  
Bitrize  

## 今後の予定  
・絞り込み画面のUIコンポーネントが多く記述量の多さが目立つので  
 リファクタの検討  
・テストコード整備




