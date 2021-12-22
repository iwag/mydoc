これは[Nulab Advent Calendar 2021](https://adventar.org/calendars/6767)の記事です

---
# はじめに
ずっとやらないと思っていても放置されているプロダクト上の課題はありませんか？ずっと改善しないと思っているが優先度をあげられない課題とか。このブログでは、私たちNulab Appsチームとカスタマーサポートチームが取り組んだ、なんらかのトラブルで2段階認証でログインできなくなっちゃう問題への取り組みについて書きます。ここでカスタマーサポートがでてくるのは、この問題のサポートチケットに毎日向き合っているのがカスタマーサポートであったからです。


このプロジェクトでは以下の改善行いました。
- [2段階認証入れなくなったユーザーのためのヘルプ（新規）](https://support.nulab.com/hc/ja/articles/4409145099673-2%E6%AE%B5%E9%9A%8E%E8%AA%8D%E8%A8%BC%E3%81%A7%E3%83%AD%E3%82%B0%E3%82%A4%E3%83%B3%E3%81%A7%E3%81%8D%E3%81%AA%E3%81%8F%E3%81%AA%E3%81%A3%E3%81%9F%E3%81%A8%E3%81%8D%E3%81%AF)
- [バックアップの認証方法に関する啓蒙ブログ](https://nulab.com/ja/blog/nulab/how-to-2fa-backup/)
- UI改善
<p align="center">
<img src="https://i.imgur.com/vJ5klbd.png" alt="諸事情により手書き" center width="340"/>
  <br>
  改善した2段階認証設定後のモーダルのイメージ
</p>

いずれの施策も、2段階認証のバックアップを設定してもらったり自分でバックアップの手段でログインできるようになったりと、ユーザーにセルフサービスで解決してもらいたいという意図が込められていいます。ゆくゆくはサポートチケットが減るといいなと思っています。

この文章には、かっこいい解決法もスカッとエピソードもありません。結局のところ、そういう問題あるあるだよね～結局人の信頼感大事だよね～リモート時代に大変だよね～という結論になっております。何かのいちアネクドートになりましたら幸甚でございます。

# 問題の説明

ユーザーがさまざまの理由で2段階認証の2段階目の認証（SMSや認証アプリ、セキュリティキー）に入れなくなっちゃうという問題です。さらにユーザーの問い合わせに対応するカスタマーサポート内での労力という意味のコストの問題もあります。

まず、2段階認証の2段階目の認証ついては、忘れないでほしいなーという気持ちなのですが（2段階認証はセキュリティを高め、あなたであるという認証であり大切なデータを守るという意味で）、とはいえ人間、忘れちゃったりなくしちゃったりすることもありますよね。私自身の体験としてセキュリティキーを家に忘れて出社してしまったり、スマートフォンの機種変更で既存の認証アプリを忘れてしまい、セッションが残っている端末から間一髪で新しい認証アプリを登録できたということがありました。（こういう事故がおこるのでGoogle Authenticatorといった非クラウド型の認証アプリは微妙かも。ちなみにあるサービスはAuthyといったクラウド型の認証アプリをおすすめしているところがありました、確かに！）。

とはいえ、ヌーラボアカウントの2段階認証にはそういったときのために万が一のバックアップの認証方法（例えばバックアップコードなど）が用意されていますし、2段階認証の設定時にバックアップを設定しましょうとメッセージを表示していました。なんで使ってくれないんだろう？というのが実際の本音でした。

また、カスタマーサポートの面では、この種のサポートチケットを何件も処理していました。カスタマーサポート側のオペレーションという面でも（例えば、本人確認は厳格なプロセスが必要なためどうしても確認業務や人手を介さないといけない等）効率化、自動化にも限界があります。この種のサポートチケットはユーザーベースの増加とともに今後も増加していくことが容易に予想されます。

上記、問題自体のむずかしさ以外にも構造的なむずかしさもあったと考えています。
この何らかの理由で2段階認証で入れない問題場合、困っている人と解決する人が異なっています。この場合、困っている人は2段階認証に入れなくなってしまったNulab Appsのエンドユーザーであり、毎日このサポートチケットを処理しているカスタマーサポートの方です。一方で、問題を解決する人はNulab Appsチームとなります。[プリンシパルエージェント問題](https://ja.wikipedia.org/wiki/%E3%83%97%E3%83%AA%E3%83%B3%E3%82%B7%E3%83%91%E3%83%AB%EF%BC%9D%E3%82%A8%E3%83%BC%E3%82%B8%E3%82%A7%E3%83%B3%E3%83%88%E7%90%86%E8%AB%96)みたいですね！セクションをはさむほど、現場の温度感は距離の2乗に比例して伝わらなくなるといわれています。フルリモートになってるのも困難性を高めています。

<p align="center">
<img src="https://i.imgur.com/qh6afid.png" alt="諸事情により手書き"  width="600"/>
  <br>
  俺たちのプリンシパルエージェント問題
</p>

また、課題をボールにたとえることがありますが、ユーザーから投げられるボールをひろっているのはカスタマーサポートの方です。外から見るとボールが落ちていることに気づかないということがあります。昨今のコロナ禍のフルリモートでますます見えなくなっている気がします。まあ要するに優先度をあげることができなかったということです。

# 解決編

以下解決編です。繰り返しになりますがスカッとする話ではないです…。

## 意識付け

問題は勝手になくなりません（そういうこともあるけど）、結局のところそういった放置タスクに対して「俺がなんとかしないと…」と思えるかではないでしょうか。
とはいえ、プロダクトのロードマップ、優先度があるのは事実。今あるタスクやプロジェクトをとめて、P0で直すべきかといわれると、P1くらいで直すべきと思うけど、、、ステークホルダーを説得するコストを考えるとうーんとなって手が止まる。それでも、やらないといけないことはあると思うのですがどうでしょう？自分の中に物差しをもっていますか？

## 3度目の協業
<p align="center">
<img src="https://i.imgur.com/WXP05LF.png" alt="3"  width="540"/>
  <br>
  3
</p>
いったん自分でやると決めてしまえば、社内チャットで声をかければという感じです。忙しい時期に声掛けしたら迷惑なのでタイミングは見図らないといけないですが。
Appsチームとカスタマーサポートの共同プロジェクトは私が覚えてるだけで今回で3回目。
1回は2020年12月のインシデント対応、2回目はUXライティングの勉強会です。特にUXライティングの勉強会をしたおかげで、両チームの共通言語が育ってきていました。ユーザー体験への知見も、プロダクトへの理解も深まっておりました。

最後に私事ですが福岡メンバー数人とはキャンプにいったこともございます。
ですので、Appsチームとカスタマーサポートの間に人間関係、信頼関係ができており声を上げたら協力してくれるだろうという確信はありました。数字を出したりROIやコストベネフィットといった理詰めな理由づけも重要ですが最後に必要になるのはこういったウェットな信頼関係ではないでしょうか。

## 問題に取り組む
Appsチーム、カスタマーサポートで週一回1時間ほどのミーティングを繰り返し現状の掘り下げ、各メンバーの肌感（重要です）、セキュリティ・アカウントの要件を共有しました。そうして、ユーザーで自分で解決してもらう、それによりサポートチケットを減らすとする大枠の方針をまとめることができました。

そのあとも毎週あつまり、現状のユーザー体験の理解、現状のフローを見直したりしつつ改善ポイントを探しました。実際うーんとなる点がたくさんあります。このライティングだと何をいってるかでわからないなとか何かするにもクリックが多いな！フォント小さくて見づらいな！とか。これがUI改善のヒントにつながります。
それ以外にも、2段階認証に入れなくなったユーザーがバックアップの認証手段を使って解決する手段がわかりづらい（というかない？）といった発見がありました。

これら発見をCacooにマッピングしどのへんが効果的かなーと話し合います。この時点で10人ほどの参加者がいたため（Appsチーム、カスタマーサポートで半々だったと思います）、3チームに分け（ヘルプ、ブログ、UI改善）にわけ以後は各サブチームで話し合いながら進めました。途中、だれてしまうモーメントがありましたが、リリース日をかっちり決め、、、前述のとおり3回目となりますので進めやすかったです。
ちなみに毎週の定例の1時間プラス1時間ほどの作業量だったのもよかったと思います。UIの変更に取り組んだ私はほとんどつきっきりでしたが、、、Alertifyつらかった…。

と、できたのが冒頭に書きましたヘルプ、ブログ、UIの更新となります。

# まとめ
私たちが取り組んだ2段階認証改善のミニプロジェクトについて書かせていただきました。こういったご時世で、チーム外の関係が作りにくいという困難な時代ではございますががんばっていきましょう。

<p align="center">
<img src="https://i.imgur.com/XCcg2jf.jpeg"   width="640"/>
</p>

文責：イワカミ