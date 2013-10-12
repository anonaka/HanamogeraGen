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

load File.join(File.dirname(__FILE__),'table-100nin.rb')

puts "one char:" + $one_char_table.length.to_s
puts "two chars:" + $two_chars_table.length.to_s
puts "tail chars:" + $tail_chars_table.length.to_s
