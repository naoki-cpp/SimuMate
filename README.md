# SimuMate
![Publish Docker](https://github.com/naoki-cpp/SimuMate/workflows/Publish%20Docker/badge.svg)
## 概要
第一原理計算用．
## Docker
イメージがDocker Hubの`naokicpp/simu_mate:latest`にある．
Dockerがインストールされていれば以下でpullできる．
```shell
docker pull naokicpp/simu_mate:latest
```
## Docker-compose
docker-composeを用いると`docker run`の一連の動作を一括で行える（参考：[dockerコンテナの中でguiアプリケーションを起動させる](https://unskilled.site/docker%E3%82%B3%E3%83%B3%E3%83%86%E3%83%8A%E3%81%AE%E4%B8%AD%E3%81%A7gui%E3%82%A2%E3%83%97%E3%83%AA%E3%82%B1%E3%83%BC%E3%82%B7%E3%83%A7%E3%83%B3%E3%82%92%E8%B5%B7%E5%8B%95%E3%81%95%E3%81%9B%E3%82%8B/)）．
```
docker-compose up -d
```
の後，
```
docker-compose exec local-linux bash
```
とすればコンテナを起動できる．
## Jupyter Notebook
Jupyter Notebookを使うには，portオプション
`-p 8888:8888`を付けて，
```
docker run -it --rm -e -p 8888:8888 naokicpp/simu_mate:latest
```
などとしてからコンテナ内で
```
jupyter notebook --port 8888 --ip=0.0.0.0 --allow-root
```
を実行するとurlが発行されるのでそこにホスト側からアクセスすると使える．
## 入っているもの
- Quantum Espresso．buildした時点での最新版が入る．
- Atomic Simulation Environment．これもbuildした時点での最新版が入る．
- OOMMF(The Object Oriented MicroMagnetic Framework)．[Alpha release of OOMMF 2.0](https://math.nist.gov/oommf/software-20.html)がインストールされている．`oommf`コマンドで起動．
- [SPIRIT](https://github.com/spirit-code/spirit)．`spirit`コマンドで起動．
