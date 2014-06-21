
rm mp3.txt
for i in 0 5 10 15 20 25 30 35; do
	 curl -s http://d.hatena.ne.jp/iandme/\?of\=0 | grep mp3Url | grep t-p | grep param | ruby -ne 'puts $_.match(/http.+mp3/).to_s'
done > mp3.txt

rm title.txt
for i in 0 5 10 15 20 25 30 35; do
	curl -s http://d.hatena.ne.jp/iandme/\?of\=0 | nkf -w | grep class=\"title | ruby -ne '$_.match(/\d\">(.+?)<\/a/); puts $1'
done > title.txt

ruby ../daily/toRss.rb mp3.txt title.txt
