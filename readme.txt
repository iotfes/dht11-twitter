#----------------------------------------------------------------------
# dht11-tweet.rb
# ver.1.0
# 2017/01/18
# DHT11温湿度センサから最新の温度、湿度を取得し、Twitterへ投稿するプログラム
#----------------------------------------------------------------------

○前提
- Raspberry piにCumulocity Agentをインストールしており、正常に接続していること。
- Raspberry piのAdministrationアプリの"Own applications" -> "Create application"よりアプリケーション情報を登録し、App-Keyを取得していること。(App-Key登録画面例.png参照)
- Twitterアカウントを所有しており、下記の値を取得していること。
-- consumer_key
-- consumer_secret
-- access_token
-- access_token_secret
-- 詳細は下記を参照：http://hello-apis.blogspot.jp/2013/03/twitterapi.html

○セットアップ
- Twitter用Rubyライブラリをインストール
$ sudo gem install twitter

○動作例
sho-pc:cumulocity sho$ ruby dht-tweet.rb 
https://nttcom.cumulocity.com/measurement/measurements?dateFrom=2017-01-18&dateTo=2017-01-19&type=c8y_dht11&revert=true&pageSize=1
会議室Cの温度は21.0度、湿度は34.0%です。(2017年01月18日 12:02:03現在)
Twitterへ投稿しました。
