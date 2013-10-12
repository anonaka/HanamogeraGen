#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'pp'
require 'csv'

class HanaAnalyzer
  def initialize(n)
    @h_begin = Hash.new
    @h_begin.default = 0
    
    @h_mid = Hash.new
    @h_mid.default = 0

    @h_end = Hash.new
    @h_end.default = 0

    @level = n
  end

  def analyze_connection(ph)
    len =  ph.length
    blk_count = len - @level + 1
    i = 0
    while i < blk_count
      str = ph[i..(i + @level - 1)]
      @h_mid[str] += 1
      i += 1
    end

    # 文頭用hash
    str = ph[0..(@level - 1)]
    @h_begin[str] += 1
    
    # 文末用hash
    str = ph[(-@level)..(-1)]
    @h_end[str] += 1
  end
  
  def get_result
    return @h_mid
  end
end

# main program

ha = HanaAnalyzer.new(4)

while l = gets
  data = l.chop().split(',')
  5.times do |i|
    phrase = data[i+1]
    ha.analyze_connection(phrase)
  end
end

ha.get_result.to_a.each { |x| print x.to_csv }


