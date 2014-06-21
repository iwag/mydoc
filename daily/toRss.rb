require 'date'
f1 = File.open(ARGV[0])
f2 = File.open(ARGV[1])

while title = f1.gets
  mp3 = f2.gets
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

