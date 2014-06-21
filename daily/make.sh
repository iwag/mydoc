
rm mp3.txt
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13; do curl -s http://portal.nifty.com/cs/stream/list/$i.htm | nkf -w | grep mp3 | ruby -ne 'puts $_.match(/(http:\/\/portal.nifty.com\/radio\/hiru.+?\.mp3)/).to_s.chomp' | grep http ; done > mp3.txt
rm title.txt
for i in 1 2 3 4 5 6 7 8 9 10 11 12 13; do curl -s http://portal.nifty.com/cs/stream/list/$i.htm | nkf -w | grep title= | grep -v "title=.ラジオ"| grep -v "ユーストリーム" | grep -v "ニコニコ" | grep -v "カルチャークラブ" | grep -v "USTREAM" | ruby -ne ' $_.match(/title="(.+)"/); puts $1.chomp'| uniq ; done > title.txt

ruby toRss.rb mp3.txt title.txt
