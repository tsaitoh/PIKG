# PIKG (Ver 0.0)
本プロジェクトは，FDPS( https://github.com/FDPS/FDPS )およびその他の粒子系シミュレータの粒子間相互作用カーネル関数の自動ジェネレータである.
粒子間相互作用をDSLで記述し，パラメータを指定すると，任意のアーキテクチャ(Intel CPU, Fujitsu A64FX, NVIDIA GPU, PEZY-SC2, etc.)向けのカーネルを生成する．

# 動作環境
Ruby環境が必要．ruby 2.3.7で動作確認．

# 言葉の定義
## 粒子系シミュレータ
粒子が互いに作用しながら時間発展するような系を扱うシミュレーションプログラム．分子動力学，N体，SPHシミュレーションプログラムなどがこれにあたる．

## カーネル
2粒子間の相互作用を計算する関数．
相互作用を受ける粒子のインデックスを*i*，相互作用を与える粒子のインデックスを*j*とすると，
カーネルは*i*と*j*の二重ループで記述することができる．

# 目標とする機能
- 粒子間相互作用とそれに必要な数式を書くだけでカーネルが記述できる．
- *i*並列と*j*並列の並列数を任意の組み合わせで作ることができる(16 SIMDの場合，組み合わせは(16,1),(8,2),(4,4),(2,8),(1,16)の5通り)．
- ターゲットアーキテクチャごとに自動でコードを生成する
- 計算量が重い部分に関しては，区間多項式近似の導入など最適化を行う？

# 実装された機能
- 粒子間相互作用とそれに必要な数式を書くだけでカーネルが記述できる．
- ターゲットアーキテクチャごとに自動でコードを生成する
- table関数を用いることで区間多項式近似を使えるようにした

# 文法
仕様書(doc/kernel_generator_spec.pdf)を参照のこと．

# how to use
```
$(PIKG_DIR)/bin/pikg -i (input_file) -o (output_file) [options]
```
output_fileにC++のヘッダーファイルができるので相互作用計算の構造体(デフォルトclass名Kernel)を利用する
生成されたヘッダーファイルを利用してコンパイルする際には./inc/pikg_vetor.hppに宣言されている型が使われているのでインクルードする
詳細についてはdoc/kernel_generator_spec.pdfを参照ください．

現在参照できるサンプルは以下のとおりです．
> ./sample/LennardJones

> ./sample/Nbody

それぞれに関しては，各ディレクトリのREADME.mdをご参照ください．

# 目標とする最適化可能な命令セット
- AVX2
- AVX-512
- ARM SVE
- CUDA
- PZCL

# 実装された命令セット
- AVX2
- AVX-512
- ARM SVE

# 参考性能
N体計算カーネルのシングルスレッド性能をアセンブラレベルでチューニングされている(AVX2のみ)ライブラリPhantom-GRAPE( https://bitbucket.org/kohji/phantom-grape/src/master/ )との比較として置いておく．

|    | AVX2 | AVX-512 | ARM SVE |
|----|------|---------|---------|
|  PG| 59.4 |  97.0   |   N/A   |
|PIKG| 66.8 | 108.6   |  34.3   |

性能計測にはFDPSのサンプル「nbody」を利用．
AVX2/AVX-512の計測ではIntel Xeon Gold 6140を，ARM SVEでの計測にはFujitsu A64FXを利用．単位はGflops．n_group_limit(FDPSに渡されるパラメータ．この数までの粒子の相互作用リストを一つにまとめる)は512．
ARM SVEに関しては，A64FX向けに専用の最適化オプションやプラグマを利用(詳しくは仕様書を参照)．
