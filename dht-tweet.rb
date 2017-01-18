# coding: utf-8
#----------------------------------------------------------------------
# dht11-tweet.rb
# ver.1.0
# 2017/01/18
# DHT11温湿度センサから最新の温度、湿度を取得し、Twitterへ投稿するプログラム
#----------------------------------------------------------------------
# coding: utf-8
$LOAD_PATH.push('.')
require 'twitter'
require 'yaml'
require 'net/https'
require 'time'
require 'json'
require './http_lib.rb'

#----------------------------------------------------------------------
#                          設定ファイル読み込み
#----------------------------------------------------------------------
confFileName = "./config.yml"
config = YAML.load_file(confFileName)

# 会議室名
ROOMNAME = config["room_name"]

# Twitterアカウント情報
client = Twitter::REST::Client.new(
  consumer_key:        config["twitter"]["consumer_key"],
  consumer_secret:     config["twitter"]["consumer_secret"],
  access_token:        config["twitter"]["access_token"],
  access_token_secret: config["twitter"]["access_token_secret"]
)
# Cumulocity API情報
host = config["c8y"]["host"]
keys = {
  username: config["c8y"]["username"],
  password: config["c8y"]["password"],
  appkey: config["c8y"]["appkey"]
}
# fragmentTypeを指定
dht11FragmentType = config["c8y"]["fragmentType"]

#----------------------------------------------------------------------
#                            メイン処理
#----------------------------------------------------------------------
begin

  #------ Cumulocityから温湿度センサのデータを取得 ------
  uri = "/measurement/measurements"
  result = getLatestData(host, uri, keys, "c8y_dht11")
  # エラーチェック(DHT11)
  if result["measurements"] == nil then
    puts result
    raise "error in DHT11"
  end
  
  # 温度と湿度を取得
  currentTemperature = result["measurements"][0]["#{dht11FragmentType}"]["temperature"]["value"]
  currentHumidity = result["measurements"][0]["#{dht11FragmentType}"]["humidity"]["value"]

  # 測定時刻を取得
  measureTime = Time.strptime(result["measurements"][0]["time"], "%Y-%m-%dT%H:%M:%S").strftime("%Y年%m月%d日 %H:%M:%S")

  # Twitterへ投稿
  tweetStr = "#{ROOMNAME}の温度は#{currentTemperature}度、湿度は#{currentHumidity}%です。(#{measureTime}現在)"
  puts tweetStr
  client.update(tweetStr)
  puts "Twitterへ投稿しました。"
  
rescue => e
  puts e.message
  exit
end
