#!/usr/bin/ruby

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

require 'cgi'
load 'hanamogera.rb'
cgi = CGI.new
len = cgi['length'].to_i

if (1 <= len) and (len <= 1000)
  str = gen_hanamogera(len)
else
  str = ""
end


if cgi['output'] == 'json'
  require 'json'
  header = {'type' => 'application/json; charset=UTF-8', 'status' => 'OK'}
  page = {:hanamogera => str}.to_json
else
  header = {'type' => 'text/html', 'status'=>'OK'}
  tracking ="<script type='text/javascript'>
    var _gaq = _gaq || [];
    _gaq.push(['_setAccount', 'UA-5037492-2']);
    _gaq.push(['_trackPageview']);

    (function() {
      var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
      ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
      var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
    })();
  </script>"
  content_type = "<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>"

  page = "<html><head>" + content_type + tracking + "</head><body>" + str + "</body></html>"
end
cgi.out(header){page}
