GPU Advent Calendar 2012 XX日目の記事です。

あのだよ、
ワス今さらなんだケドGPGPUに興味がでてきてCUDAなんか調べてたら、お声がかかってこういう書いているわけですよ。
GPUやろうと思ったのも特になんか作りたいものがあったりするわけじゃないケド、やっぱりGPU使う以上早くなって欲しいわけじゃんか。
でいろいろ本とかNVIDIAの資料とかウェッブで資料読んだりしてるわけです。
だけどもさあ、これはバンド幅制限だすよとかコアレッシングですよとかシェア度メモリがバンクコンフリクトとか分岐がしてますよとか。
いやぁワスみたいな初心者にはプログラムみてここがコアレッシングだよとか正直きびしい。
まあ作ってみて測ればいいじゃんとか言われるとぐぅの音もでないんだケドさ、ワスは高速化するために行きつ戻りとかしたくないんだよ！！
というかワス、ホント情けないことなんだケド、コアレスアクセッシングとかワープダイバージェンスとか何度読んでもゼンゼンわかんないねえですよ…。

そもそもだよ、ワスのプログラムを食わせたら、ココとココが～～～で効率が悪いですヨって言ってくれるプログラムとかないんですか！
あるんですよ！
ってことで今回はCUDAのプロファイラで取れるカウンタの値について紹介します（前フリながくて申し訳ないケド…）。

## nvprof

これから書くことは別にワスが思いついたことじゃなくて、この発表資料がネタ元になってます。

 GPU Performance Analysis and Optimization
<http://developer.download.nvidia.com/GTC/PDF/GTC2012/PresentationPDF/S0514-GTC2012-GPU-Performance-Analysis.pdf>

 Analysis Driven Optimization
<http://www.cs264.org/lectures/files/Analysis_driven_optimization.pdf>

ところで、CUDA 5.0 からプロファイラ（nvprof）が新しくなったんだよ。
nvprofを使うのは簡単で、このへんのドキュメント<http://docs.nvidia.com/cuda/profiler-users-guide/index.html#nvprof-overview>を読めばわかります。
正直nvprofの使い方はどーでもよくて、なぜなら以前から環境変数セットして使うプロファイラとかVisual Profiler使えば見えたんだし。といってもワスnvprof以外で試してないんだよね…。
じゃnvprofなにがうれしいのかって言われたら、ほらあれじゃんか、nvprofお手軽でいいじゃんか！

ここにnvprofの説明があったんだケド、tanakmuraさんの記事<http://d.hatena.ne.jp/w_o/20121211#1355236028>とかぶってんるんで男らしく割愛するよ！

（略）

ここまではマニュアルにのってることしか書いてないですよ（本来はここにnvprofの説明があったんだよ）、というかココまで読んでくれてる人がどれダケいるのかまったく予想できないんだケド、これからもこんな感じで進んでいくですよ。
で、こっから実際に計測した値を元に分析みたいなことをしていきますよ。

-query-printするとたくさんの種類のカウンタが出てくるんだケド、どれを見ればいいのかっていうと、前出の資料によると注目すべきは以下の6つらしいです。

+ グローバルメモリ
 + gld_request, gst_request
 + l1_global_load_hit, l1_global_load_miss, global_store_transaction
+ Shared memory
 + l1_shared_bank_conflict
+ 命令
 + instructions_issued, inst_executed
+ 分岐
 + branch, divergent_branch

ただし、これらカウンタの名前はバージョンによってちょいちょい変わるみたいなので、正確にはnvprof --query-events で確認してください。

### 余談：instruction_issued

ちょいちょい変わるといっても変わってるのでワスが知ってるのはinstruction_issuedダケで、これがcompute capabilityによって変わるみたいです。

compute capability 2.0 （たぶん）まではinstruction\_issuedなんですが、2.1以降はinstruction\_issuedがなくなって

 + inst_issued1_0:  Number of single instruction issued per cycle
 in pipeline 0.
 + inst_issued2_0:  Number of dual instructions issued per cycle
in pipeline 0.
 + inst_issued1_1:  Number of single instruction issued per cycle
 in pipeline 1.
 + inst_issued2_1:  Number of dual instructions issued per cycle
in pipeline 1.

の4つに細分化されています（ちなみに上の結果はGT620のnvprof --query-eventsより）。
 で、compute capability 2.1以降では

instruction\_issued = inst_issued1_0 + inst\_issued2_0 x 2 
   					+ inst_issued1_1 + inst_issued2_1 x 2 

で計算すればよいかと思います。
 根拠はhttp://docs.nvidia.com/cuda/cupti/index.html#r_metric_reference_3x の表です。
 compute capability 2.1なのになぜ3xかはわかりません…。

## コアレッシングアクセス

CUDAの本とかマニュアルみると猫も杓子もコアレッシング・コアレッシングって言ってるケドもさ（実際言ってないケド…）、
プロファイラを使うことでコアレッシングアクセスにちゃんとなってるか確認することができます。

CUDAの一番最初のサンプルであるvectorAddの簡単なカーネルで調べてみますよ。
```
 __global__ void vectorAdd(float *d_A, float *d_B, float *d_C) {
 	int i = blockIdx.x * blockDim.x + threadIdx.x;
 	d_C[i] = d_A[i] * d_C[i];
 _}
```


今回のネタ元になってる1番目の資料によると（スライド４０あたりです）、
トランザクションって考えでわかるらしいですよ。

カーネル関数のロードやストアの幅に注目しますよ。

- 4バイトのロード・ストア→ 1.0
- 8バイトのロード・ストア→ 2.0
- 2バイトのロード・ストア→ 0.5

ロードとかストアの回数は関係ないです。
バイトが混在してる場合は比率で計算します。

ロード、ストアそれぞれでトランザクションを計算してみましょう。

 + load:
 1 transactions
 + store:
 1 transactions
 
floatのロードストアなんでどっちも1です。
ここで計測すべきは次の5つのカウンタです。

- load transaction
 - gld_request
 - l1_global_load_miss
 - l1_global_load_hit
- store transaction
 - gst_request
 - global_store_transaction


で、見積もったトランザクション数とプロファイラで得られた値とを見ていきますよ。
ブロック数を適当にしました。これはコアレスじゃないですね。
```
vectorAdd<<<250,200>>>(d_A, d_B, d_C);
```

 このときのトランザクションを計算してみますよ。

 + gld_request_:
  3500
 + l1_global_load_miss_:
  3512
 + l1_global_load_hit_:
  1472
 + load transaction:
 (3512+1472) / 3500 = *1.4*
 
 + gst_request_:
  1750
 + global_store_transaction:
  2628
 + store transaction:
  2628/1750 = *1.5*

見積もったやつよりかなり多いですね。

一方以下のようにスレッドブロックの数をワープの数にしてコアレッシングアクセスに変えると、
```
vectorAdd<<<1000,256>>>(d_A, d_B, d_C);
```

 + gld_request_:
  3126
 + l1_global_load_miss_:
  3200
 + l1_global_load_hit_:
  0
 + load transaction:
  (0+3200)/3126 = *1.0*
 + gst_request_:
  1563
 + global_store_transaction:
  1612
 + store transaction:
  1612 / 1563 = *1.0*


見積った値と同じになりましたよ。

注目すべきはコアレッシングだとl1_global_load_hitが0になっている点で、
規則的なアクセスだとL1にヒットすることはないけど、コアレッシングじゃないと不規則なので
L1にヒットすることがあるという意味なのかなとおもいます。

ちなみに、命令発行数と実行数をみると、

+ コアレッシングじゃない
 + inst_issued_:
  39201
 + inst_executed_:
  33250
+ コアレッシング
 + inst_issued_:
  33976
 + inst_executed_:
  29732

という感じで発行数も実行数も増えてます。例がよくないというのもあります…。

ちなみにすべてGT620で測ってて、GTX680もあったんだケド、l1_global_load_hit, missともに0になるんだよね…。

## shared memory
バンクコンフリクトよくわかんないですよ。

sharedのバンクコンフリクトの場合、そのものずばりなl1_shared_bank_conflict_というのがあってそれをみればよいです。

使うのはreductionのサンプルです。
reduce1→reduce2でバンクコンフリクトを除去してるので。

+ reduce1
 + l1_shared_bank_conflict 7,374,600
+ reduce2
 + l1_shared_bank_conflict 0

ちなみにもうちょっと詳しい説明が、2つめの資料のスライド36あたりにあります。

## 分岐
分岐まで行きたかったけど、時間がないので分岐は次回（たぶんないケド）。



