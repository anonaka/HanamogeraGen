#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require 'net/http'
require 'uri'
require 'nokogiri'
require 'json'

len = 7
hd = 3

def split_at(str,n)
  str[0..(n-1)] + "," + str[n..(-1)]
end

url =  URI.parse("http://truelogic.biz/hanamogera/get-hanamogera?length=#{len}")
resp = Net::HTTP.get url
doc = Nokogiri::HTML.parse(resp, nil, nil)
hanamogera =  doc.xpath('html/body').text

#hanamogera = split_at(hanamogera,hd)

url = URI.encode("http://www.google.com/transliterate?langpair=ja-Hira|ja&text=#{hanamogera}")
url = URI.parse(url)
resp = Net::HTTP.get url
kanji_a = JSON.parse(resp)

honbun = ""
yomi = ""
kanji_a.each do | x |
  # select the candidate rondomly
  i = rand(x[1].length - 1)
  honbun += x[1][i]
  yomi += x[0]
end

puts honbun
puts "(#{yomi})" 



