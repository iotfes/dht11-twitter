# coding: utf-8
require 'base64'

def httpsPostQuery(hostname, uripath, initheader, payload, use_ssl)
  # ホスト名、URLを設定
  host_rawdata_uri = hostname + uripath
  uri = URI.parse(host_rawdata_uri)  
  #puts host_rawdata_uri
  
  uri = URI.parse(host_rawdata_uri)
  response = nil
  
  # APIリクエストを作成
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = use_ssl
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  puts initheader
  
  # HTTPの設定
  request = Net::HTTP::Post.new(uri.request_uri, initheader)
  request.body = payload
  #puts payload
  #http.set_debug_output $stderr
  
  # APIリクエストを送信
  response = http.request(request)
  return response

  # 結果を解析
  #json = JSON.parse(response.body)

  #return json  
end

def httpsGetQuery(hostname, uripath, params, initheader, use_ssl)
  # ホスト名、URLを設定
  host_rawdata_uri = hostname + uripath
  uri = URI.parse(host_rawdata_uri)  
  uri.query = URI.encode_www_form(params)
  #  req = Net::HTTP::Get.new uri
  host_rawdata_uri += "?"
  host_rawdata_uri += uri.query
  puts host_rawdata_uri
  
  uri = URI.parse(host_rawdata_uri)
  response = nil
  
  # APIリクエストを作成  
  request = Net::HTTP::Get.new(uri.request_uri, initheader)
  
  # HTTPの設定
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = use_ssl
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE 
  #http.set_debug_output $stderr
  
  # APIリクエストを送信
  http.start do |h|
    response = h.request(request)
  end

  # 結果を解析
  json = JSON.parse(response.body)

  return json  
end


def getLatestData(host, uri, keys, type)

  day = Time.now
  dateFrom = day.strftime("%Y-%m-%d")
  dateTo = (day + 24*60*60).strftime("%Y-%m-%d")
  
  query_params = {
    dateFrom: dateFrom,
    dateTo: dateTo,
    type: type,
    revert: "true",
    pageSize: "1"
  }
  # httpヘッダ
  initheader = {
    'Authorization' => 'Basic ' + Base64.encode64("#{keys[:username]}:#{keys[:password]}"),
    'X-Cumulocity-Application-Key' => keys[:appkey]
  }
  result = httpsGetQuery(host, uri, query_params, initheader, true)
  return result
  
end
