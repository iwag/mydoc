require 'date'
f1 = File.open(ARGV[0])
f2 = File.open(ARGV[1])

head = <<EOS
<rss xmlns:itunes="http://www.itunes.com/DTDs/Podcast-1.0.dtd" version="2.0">
<channel>
<link>http://portal.nifty.com/cs/stream/list/1.htm</link>
<title>デイリーポータルZラジオ</title>
<description>
<![CDATA[ デイリーポータルZがお送りするラジオです ]]>
</description>
<lastBuildDate>Sat, 21 Jun 2014 18:06:42 +0900</lastBuildDate>
<copyright>デイリーポータルZ</copyright>
<language>ja</language>
<itunes:summary>
<![CDATA[ デイリーポータルZがお送りするラジオです ]]>
</itunes:summary>
<itunes:author>デイリーポータルZ</itunes:author>
EOS

puts head

while title = f1.gets
  mp3 = f2.gets
  break unless mp3
  break unless title
  mp3.chomp!
  title.chomp!

  node = <<EOS
<item>
<link>
http://portal.nifty.com/cs/stream/detail/140512164099/1.htm
</link>
<title>
<![CDATA[ #{title} #{mp3.match(/(20\d+).mp3/); Date.parse($1).strftime("%y/%m/%d")} ]]>
</title>
<description>
<![CDATA[ #{title} ]]>
</description>
<pubDate>#{ mp3.match(/(20\d+).mp3/); Date.parse($1).rfc822}</pubDate>
<copyright>デイリーポータルZ</copyright>
<enclosure url="#{mp3}" length="0" type="audio/mpeg"/>
<itunes:summary>
</itunes:summary>
<itunes:author>デイリーポータルZ</itunes:author>
</item>
EOS
  puts node
end

puts "</channel></rss>"

