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
    #文の中間文字列のパターンをカウントする。
    #文頭と文末は除外する。
    len =  ph.length
    blk_count = len - @level
    i = 0
    while i < blk_count
      str = ph[(i+1)..(i + @level)]
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

  def sort_data_all
    @a_begin = sort_data(@h_begin)
    @a_mid = sort_data(@h_mid)
    @a_end = sort_data(@h_end)
  end

  def sort_data(h)
    # convert to array
    ar = h.to_a
    # sort by second element
    ar.sort! {|a,b| (-1) * (a[1] <=> b[1]) }
    return ar
  end

  def get_result
    return @h_begin,@h_mid,@h_end
  end
  
  def pretty_print

    puts "#!/usr/bin/env ruby"
    puts "# -*- coding: utf-8 -*-"
    puts 

    puts "$tbl_begin_%d_a = " % @level
    pp @a_begin
    
    puts "#####"

    puts "$tbl_mid_%d_a = " % @level
    pp @a_mid

    puts "#####"

    puts "$tbl_end_%d_a = " % @level
    pp @a_end
  end
end

# main program
if  __FILE__ == $0

  level = 3

  ha = HanaAnalyzer.new(level)
  
  inf = File.open('../../data/100-hiragana-uni.csv',"r")
  
  while l = inf.gets
    data = l.chop().split(',')
    5.times do |i|
      phrase = data[i+1]
    ha.analyze_connection(phrase)
    end
  end
  
  ha.sort_data_all

  #ha.get_result.to_a.each { |x| print "  " + x.to_csv }
  ha.pretty_print

end


