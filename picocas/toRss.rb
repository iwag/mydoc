require 'date'
f1 = File.open(ARGV[0])
f2 = File.open(ARGV[1])

head = <<EOS
<rss xmlns:itunes="http://www.itunes.com/DTDs/Podcast-1.0.dtd" version="2.0">
<channel>
<title>@IDA_10 x @miyaokaのピコピコキャスト</title>
<link>http://d.hatena.ne.jp/iandme/</link>
<language>ja</language>
<copyright>iandme</copyright>
<itunes:subtitle>ゲーム、映画、アメリカ文化などのトーク</itunes:subtitle>
<itunes:author>iandme</itunes:author>
<itunes:summary>主にゲーム、映画、アメリカ文化などについてトークしています。サイトの方では内容を書き起こしたまとめや補足が読めます http://d.hatena.ne.jp/iandme/</itunes:summary>
<description>主にゲーム、映画、アメリカ文化などについてトークしています。サイトの方では内容を書き起こしたまとめや補足が読めます http://d.hatena.ne.jp/iandme/</description>
<itunes:owner>
<itunes:name>iandme</itunes:name>
<itunes:email>piko2cast@gmail.com</itunes:email>
</itunes:owner>
<itunes:image href="http://www.t-p.jp/podcast/ida10_600x600.jpg"/>
<itunes:category text="Games &amp; Hobbies">
<itunes:category text="Video Games" />
</itunes:category>
<itunes:explicit>clean</itunes:explicit>
<image>
<url>http://www.t-p.jp/podcast/ida10_600x600.jpg</url>
<title>ピコピコキャスト</title>
<link>http://d.hatena.ne.jp/iandme/</link>
</image>
EOS
## FIX IT

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
</link>
<title>
<![CDATA[ #{title} ]]>
</title>
<description>
<![CDATA[ #{title} ]]>
</description>
<pubDate>#{ mp3.match(/(20\d\d\d\d\d\d).+mp3/); Date.parse($1).rfc822}</pubDate>
<copyright>ピコピコキャスト</copyright>
<enclosure url="#{mp3}" length="0" type="audio/mpeg"/>
<itunes:summary>
</itunes:summary>
<itunes:author>iandme</itunes:author>
</item>
EOS
  puts node
end

puts "</channel></rss>"

