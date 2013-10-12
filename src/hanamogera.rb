#!/usr/bin/ruby
# -*- coding: utf-8 -*-

# Hanamogera Tanka Generator
# Copyright (C) 2013 Akira Nonaka
#
# This file is part of HanamogeraGen.
#
#  HanamogeraGen is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or (at
# your option) any later version.  HanamogeraGen is distributed in the
# hope that it will be useful, but WITHOUT ANY WARRANTY; without even
# the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
# PURPOSE. See the GNU General Public License for more details.  You
# should have received a copy of the GNU General Public License along
# with HanamogeraGen. If not, see <http://www.gnu.org/licenses/>.

require 'json'
require 'uri'
require 'net/http'

load File.join(File.dirname(__FILE__),'table-100nin.rb')

def gen_first_char()
  r = rand()
  accum_index = 3
  j = $one_char_table.length
  $one_char_table.each_with_index { |elem,i|
    if elem[accum_index] >= r
      j = i
      break
    end
  }
  return $one_char_table[j][0]
end

def get_next_char(c)
  candidates = ""
  $two_chars_table.each { | elem |
    if c == elem[0][0]
      candidates += elem[0][1]
    end
  }
  l  = candidates.length
  if l == 0
    return gen_random()
  else
    return candidates[rand(l)]
  end
end

def gen_random()
  l = $one_char_table.length
  $one_char_table[rand(l)][0]
end

# def gen_hanamogera(i)
#   i -= 1
#   str = gen_first_char()
#   i.times do 
#     str += get_next_char(str[-1])
#   end
#   return str
# end

def gen_hanamogera(i)
  return "" if i <= 2
  i -= 2
  str = gen_first_char()
  i.times do 
    str += get_next_char(str[-1])
  end
  str += get_tail_char(str)
  return str
end

def get_tail_char(s)
  c = s[-1]
  candidates = ""
  $tail_chars_table.each { | elem |
    if c == elem[0][0]
      candidates += elem[0][1]
    end
  }
  l  = candidates.length
  if l == 0
    return get_next_char(c)
  else
    return candidates[rand(l)]
  end
end


# transpose buf fot vertical writing
DOUBLEBYTE_WHITESPACE = "　"
def hana_convert_vert(inbuf)
  outbuf = []
  maxlen = 0
  linecount = inbuf.length
  inbuf.each {|l|
    maxlen = l.length if maxlen < l.length
  }
  j = 0

  # transpose buf
  while j < maxlen
    outbuf[j] =  ""
    i = linecount - 1
    while 0 <= i
      if inbuf[i].length > j
        outbuf[j] += inbuf[i][j]
      else
        outbuf[j] +=  DOUBLEBYTE_WHITESPACE
      end
      i -= 1
    end
    j += 1
  end
  outbuf
end

def generate_tanka()
  generate_haiku()
  puts gen_hanamogera(7)
  puts gen_hanamogera(7)
end

def generate_haiku()
  puts gen_hanamogera(5)
  puts gen_hanamogera(7)
  puts gen_hanamogera(5)
end

def generate_tanka_vert()
  buf = []
  buf.push gen_hanamogera(5)
  buf.push gen_hanamogera(7)
  buf.push gen_hanamogera(5)
  buf.push gen_hanamogera(7)
  buf.push gen_hanamogera(7)
  reslt = hana_convert_vert(buf)
  reslt.each { |x| puts x}
end

def gen_hanamogera_kanji(i)
  str = gen_hanamogera(i)
  return convert2kanji(str)
end

# convert to Kanji  support
# 7/27/2013

def convert2kanji(str)
  # very special treatment for length = 7
  if str.length == 7
    str = split_at(str,3)    
  end

  url = URI.encode("http://www.google.com/transliterate?langpair=ja-Hira|ja&text=#{str}")
  url = URI.parse(url)
  resp = Net::HTTP.get url
  kanji_a = JSON.parse(resp)

  honbun = ""
  yomi = ""
  kanji_a.each do | x |
    # select the candidate rondomly
    #i = rand(x[1].length - 1)
    # check bad conversion
    originalHiragana = x[0]
    candidatesList = x[1]
    yomi += originalHiragana
    candIsGood = false
    for i in 0..(candidatesList.length-1)
      candstr = candidatesList[i]
      next if containBadChar(candstr)
      # candidate is good
      candIsGood = true
      break
    end
    if candIsGood
      honbun += candstr
    else
      honbun += originalHiragana
    end
  end
  return honbun
end

def split_at(str,n)
  str[0..(n-1)] + "," + str[n..(-1)]
end

def generate_tanka_kanji()
  [5,7,5,7,7].each { |i|
    puts gen_hanamogera_kanji(i)  
  }
end

# check bad kanji conversion

$range_hankaku_alpha = "A".."z"
$range_zenkaku_alpha1 = "Ａ".."Ｚ"
$range_zenkaku_alpha2 = "ａ".."ｚ"
$range_zenkaku_katakana = "ァ".."ヺ"

def checkString(s,range)
  for c in range
    return true if s.include? c
  end
  return false
end

def containBadChar(s)
  return true if checkString(s,$range_hankaku_alpha)
  return true if checkString(s,$range_zenkaku_alpha1)
  return true if checkString(s,$range_zenkaku_alpha2)
  return true if checkString(s,$range_zenkaku_katakana)
  return false
end

# main program
#generate_tanka_kanji()

