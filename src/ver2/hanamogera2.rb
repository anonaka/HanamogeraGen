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
      key = phrase[(-len)..(-1)]      
      puts key
      candidates = find_connection(tbl,key,len)
    }
  end
end

if __FILE__ == $0
  level = 3
  len = level-1
  ha = Hanamogera2.new
  hanamogera = ha.pickup_random($tbl_begin_3_a)[0]  
  puts hanamogera
  key = hanamogera[1..len]
  candidate = ha.find_connection($tbl_mid_3_a,key,len)
  pp candidate

end
