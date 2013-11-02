#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'pp'

load File.join(File.dirname(__FILE__),'table-100nin-2.rb')

class Hanamogera2
  def pickup_random(ar)
    return ar[rand(ar.length-1)]
  end

  def find_connection(tbl,key,len)
    result = []
    tbl.each { |elm|
      if elm[0][0..(len-1)] == key
        result.push elm
      end
    }
    return result
  end
  
  def gen_mid(tbl,phrase,len,limit)
    count = limit - phrase.length
    count.times { 
      puts phrase
      key = phrase[(-len)..(-1)]      
      candidates = find_connection(tbl,key,len)
      if candidates != []
        phrase += pickup_random(candidates)[0][-1]
      else
        puts "no candidates"
        phrase += "あ"
      end
    }
    puts phrase
  end

  def gen_mid_recur(tbl,phrase,len,limit)
    key = phrase[(-len)..(-1)]      
    candidates = find_connection(tbl,key,len)
    candidates.each { |c|
      # 文の終わりに候補の1文字を追加
      phrase += c[0][-1]
      return phrase if phrase.length >= limit
      result = gen_mid_recur(tbl,phrase,len,limit)
      if result == nil
        next
      else 
        return result
      end
    }
    return nil
  end
end

if __FILE__ == $0
  level = 3
  len = level-1
  ha = Hanamogera2.new
  limit = 5
  result = nil
  while result == nil
    hanamogera = ha.pickup_random($tbl_begin_3_a)[0]  
    result = ha.gen_mid_recur($tbl_mid_3_a,hanamogera,len,limit)
    if result == nil
      #puts "failed"
    end
  end
  puts result
end
