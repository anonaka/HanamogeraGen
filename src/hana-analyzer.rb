#!/usr/bin/env ruby
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

require 'pp'

$uni_hiragana_start = 0x3041
$uni_hiragara_end = 0x3096

def init_hiragana_hash(h)
  i = $uni_hiragana_start
  while i <= $uni_hiragara_end
    h[i.chr('UTF-8')] = 0
    i += 1
  end
end


def analyze_two_connection(s,h)
  i = 0
  while (i < s.length - 1)
    hkey = s[i..(i+1)]
    # puts hkey
    h[hkey] += 1
    i += 1
  end
end

def analyze_start_char(s,h)
  h[s[0]] += 1
end

def analyze_all_char(s,h)
  s.each_char do |c|
    h[c] += 1
  end
end

def analyze_tail_chars_connection(s,h)
  h[s[-2..-1]] += 1
end

def calculate_sum(a,index)
  sum = 0
  a.each do |x|
    # accumulate the second elemnt
    sum += x[index]
  end
  sum
end

def calculate_percentage(a, sum)
  a.each do |elem|
    elem.push (elem[1]/sum)
  end

end

def calculate_accumulation(a, index)
  accum = 0
  a.each do |elem|
    accum += elem[index]
    elem.push accum
  end
end

def print_array_in_csv(a)
  a.each do |elem|
    puts elem.join(",")
  end
end

def mypretty_print(a)
  puts "["
  a.each do |elem|
    p elem + ","
  end
  puts "]"
end

# main program

start_char_h = Hash.new
init_hiragana_hash(start_char_h)
two_char_connection_h = Hash.new
two_char_connection_h.default = 0

all_char_h = Hash.new
init_hiragana_hash(all_char_h)

tail_chars_h = Hash.new
tail_chars_h.default = 0

while l = gets
  data = l.chop().split(',')
  5.times do |i|
    analyze_all_char(data[i+1],all_char_h)
    analyze_start_char(data[i+1],start_char_h)
    analyze_two_connection(data[i+1],two_char_connection_h)
    analyze_tail_chars_connection(data[i+1],tail_chars_h)
  end
end

# convert hash to array
start_char_a = start_char_h.to_a
two_char_connection_a = two_char_connection_h.to_a
all_char_a = all_char_h.to_a
tail_chars_a = tail_chars_h.to_a

# calculate sum

stat_char_sum =  calculate_sum(start_char_a,1).to_f
two_char_sum = calculate_sum(two_char_connection_a,1).to_f
all_char_sum = calculate_sum(all_char_a,1).to_f
tail_chars_sum = calculate_sum(tail_chars_a,1).to_f

puts "Tail Chars sum:" + tail_chars_sum.to_s

# calculate percentage
calculate_percentage(start_char_a,stat_char_sum)
#p start_char_a

calculate_percentage(two_char_connection_a,two_char_sum)
#p two_char_connection_a

calculate_percentage(all_char_a,all_char_sum)
#p all_char_a

calculate_percentage(tail_chars_a,tail_chars_sum)
#p tail_chars_a

# verify percentage
#p calculate_sum(start_char_a,2)
#p calculate_sum(two_char_connection_a,2)
#p calculate_sum(all_char_a,2)

# sort by occurence (index == 1)
start_char_a.sort!  {|p,q|(p[1]<=>q[1])*(-1)}
two_char_connection_a.sort! {|p,q|(p[1]<=>q[1])*(-1)}
all_char_a.sort!  {|p,q|(p[1]<=>q[1])*(-1)}
tail_chars_a.sort! {|p,q|(p[1]<=>q[1])*(-1)}

# calculate accumulation

calculate_accumulation(start_char_a,2)
calculate_accumulation(two_char_connection_a,2)
calculate_accumulation(tail_chars_a,2)
# print array
print_array_in_csv(start_char_a)
puts "-----"
#print_array_in_csv(two_char_connection_a)
print_array_in_csv(all_char_a)
puts "-----"
print_array_in_csv(tail_chars_a)

# print ruby souce table"
puts "#!/usr/bin/env ruby"
puts "# -*- coding: utf-8 -*-"
puts "### 文字(列),発生回数,発生割合,積算発生割合"

puts "$one_char_table = "
pp start_char_a

puts

puts "$two_chars_table = "
pp two_char_connection_a

puts "$tail_chars_table = "
pp tail_chars_a
